---
name: replace-relative-imports
description: Replace relative imports (../../..) in TS/JS files with TypeScript path aliases by analyzing tsconfig.json. Processes changed files in current branch with interactive selection. Use when user wants to convert relative imports to aliases, clean up import paths, or refactor imports.
disable-model-invocation: false
---

# Replace Relative Imports with Path Aliases

Replace relative imports (e.g., `../../../components/Button`) with TypeScript path aliases (e.g., `#components/Button`) by analyzing tsconfig.json files in the codebase.

## Overview

This skill helps convert deep relative imports to cleaner path aliases, improving code readability and maintainability. It:

1. Analyzes changed TS/JS files in the current branch
2. Finds relative imports that can be replaced with existing tsconfig path aliases
3. Runs safety checks to skip dangerous replacements
4. Presents an interactive preview with checkboxes for file selection
5. Applies changes only to user-selected files

## Scope

### Included Files

- TypeScript files: `*.ts`, `*.tsx`
- JavaScript files: `*.js`, `*.jsx`
- Files changed in current branch (committed, staged, unstaged, or untracked)
- Files with relative imports that have matching path aliases

### Excluded Files

- Generated files: `*.gen.ts`, `*.gen.js`, `*.generated.ts`
- Test files: `*.test.ts`, `*.spec.ts`, `*.test.js`, `*.spec.js`
- Node modules: `**/node_modules/**`
- Build outputs: `**/dist/**`, `**/build/**`, `**/.next/**`
- Config files in root that don't contain application code

## Workflow

### Phase 1: Discovery & Analysis (Read-Only)

#### 1. Identify Changed Files

Collect all changed TS/JS files from the current branch:

```bash
# Committed + staged + unstaged changes vs master
git diff --name-only master -- '*.ts' '*.tsx' '*.js' '*.jsx'

# Untracked (brand new) files
git ls-files --others --exclude-standard -- '*.ts' '*.tsx' '*.js' '*.jsx'
```

Merge both lists (deduplicate) and filter out excluded files.

If the user provides a specific path (e.g., `/replace-relative-imports src/components/`), only process files within that path.

If the user provides `--all` flag, process all TS/JS files in the workspace (not just changed files).

#### 2. Find tsconfig.json for Each File

For each file, locate the nearest `tsconfig.json` by walking up the directory tree from the file's location.

**Resolution steps:**

1. Start from file's directory
2. Check for `tsconfig.json` in current directory
3. If not found, move up one level and repeat
4. Stop when found or reach repository root
5. If not found, skip the file (can't determine aliases)

#### 3. Parse tsconfig Path Aliases

For each tsconfig.json found:

1. Parse the JSON (handle comments if present)
2. Extract the `compilerOptions.paths` object
3. If `extends` field exists, recursively load and merge parent configs
4. Child config `paths` override parent config `paths` for the same key
5. Build a complete map of alias patterns to target paths

**Example tsconfig.json:**

```json
{
  "extends": "../tsconfig.base.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "#components/*": ["./src/components/*"],
      "#hooks/*": ["./src/hooks/*"],
      "@mx-modules/*": ["./src/modules/*"]
    }
  }
}
```

**Merged paths map:**

```javascript
{
  "#components/*": "./src/components/*",
  "#hooks/*": "./src/hooks/*",
  "@mx-modules/*": "./src/modules/*",
  // ... plus any paths from parent configs
}
```

#### 4. Analyze Imports in Each File

Read each file and extract all import statements:

**Import patterns to match:**

```typescript
// ES6 imports
import { Something } from '../../../path/to/file'
import Something from '../../../path/to/file'
import * as Something from '../../../path/to/file'
import '../../../path/to/file'

// Dynamic imports
import('../../../path/to/file')

// CommonJS (if present)
const Something = require('../../../path/to/file')
```

**For each import:**

1. Extract the import source (the path in quotes)
2. Check if it's a relative import (starts with `./` or `../`)
3. If relative, resolve the absolute path it points to
4. Check if a path alias exists that maps to the same target
5. If multiple aliases match, prefer the most specific one

**Alias matching logic:**

1. Sort aliases by specificity (longer pattern = more specific)
2. For wildcard patterns (ending in `/*`):
   - Check if resolved path falls within the alias target directory
   - Calculate the remainder after the target path
3. For exact patterns:
   - Check if resolved path exactly matches the alias target

**Example:**

```typescript
// File: frontend/src/pages/WorkOrder/Details.tsx
// Import: import { Button } from '../../../components/Button'
// Resolved: frontend/src/components/Button
// Matching alias: #components/* → ./src/components/*
// Replacement: import { Button } from '#components/Button'
```

#### 5. Run Safety Checks

For each potential replacement, validate that it's safe. **SKIP** the import if any of these conditions are true:

##### Safety Rule 1: Re-exports from Aliases

**Skip re-export statements that use path aliases.** These break runtime module wrapping tools like `import-in-the-middle`.

```typescript
// ❌ SKIP - re-export from alias
export * from '@mx-modules/workorders'
export { WorkOrderService } from '@mx-modules/workorders'

// ✅ OK - re-export from relative (can be converted if not re-export)
export * from '../../../modules/workorders'  // But still SKIP because it's a re-export!
```

**Detection:** Check if the import is part of an `export` statement.

**Reference:** ESLint rule `no-reexport-from-alias` in `packages/tooling/eslint-plugin-mx/rules/no-reexport-from-alias.js`

##### Safety Rule 2: Within-Module Relative Imports (Backend)

**Skip relative imports within the same backend module.** Code within the same module MUST use relative imports per the backend architecture.

```typescript
// File: backend/src/modules/workorders/services/WorkOrderService.ts

// ❌ SKIP - within same module, must stay relative
import { WorkOrderRepo } from '../repositories/WorkOrderRepository'
import { validateWorkOrder } from '../utils/validation'
```

**Detection:**

1. Check if file is in backend module: path matches `backend/src/modules/[module-name]/*`
2. Check if import target is in same module
3. If both true, skip

**Reference:** `backend/src/.cursor/BUGBOT.md` - Rule: "Respect Module Import Boundaries"

##### Safety Rule 3: Cross-Module Relative Imports (Backend)

**Skip relative imports that cross module boundaries in backend.** These violate module encapsulation and should use `@mx-modules/*` or module context.

```typescript
// File: backend/src/modules/workorders/services/WorkOrderService.ts

// ❌ SKIP - cross-module relative import (violates architecture)
import { AssetService } from '../../assets/services/AssetService'

// ✅ Should use module context instead (but don't auto-fix)
const result = await getModules().assets.service.doSomething(context, params)
```

**Detection:**

1. Check if file is in backend module
2. Check if import target is in different backend module
3. If true, skip (this is an architecture violation to flag)

**Reference:** `backend/src/.cursor/BUGBOT.md` - Rule: "Cross-module imports must go through the module's index.ts"

##### Safety Rule 4: No Matching Alias

**Skip imports that don't have a matching path alias.** Only replace imports where a suitable alias exists in tsconfig.

```typescript
// ❌ SKIP - no alias defined for this path
import { util } from '../../../utils/random/helper'
// No matching alias in tsconfig paths
```

##### Safety Rule 5: Workspace Package Imports

**Skip imports that are already using workspace package names.** These are not path aliases; they're managed by Yarn workspaces.

```typescript
// ❌ SKIP - workspace package, not a path alias
import { log } from '@mx-server/log'
import { permissions } from '@mx-shared/permissions'
```

**Detection:** Check if the import source doesn't start with `./` or `../` and isn't in the tsconfig `paths` map.

#### 6. Generate Preview

For each file with safe replacements:

1. Create a preview showing line numbers, original imports, and proposed replacements
2. Group by file
3. Count total replacements per file
4. List all skipped imports with reasons

### Phase 2: User Selection

#### 7. Present Findings

Show a summary:

```
Analyzing changed files...

Found 8 files with relative imports:
  ✓ 23 imports can be replaced
  ⊗ 5 imports skipped (safety rules)

Skipped imports:
  backend/src/modules/workorders/services/WorkOrderService.ts:12
    import { WorkOrderRepo } from '../repositories/WorkOrderRepository'
    → Within-module relative import (required by backend architecture)

  backend/graphql/src/resolvers/asset.ts:5
    export * from '@mx-modules/assets'
    → Re-export from alias (breaks runtime module wrapping)

  backend/src/modules/workorders/services/WorkOrderService.ts:8
    import { AssetService } from '../../assets/services/AssetService'
    → Cross-module relative import (violates module boundaries)
```

#### 8. Interactive File Selection

Use the Question tool to present checkboxes for each file with changes:

```
Select files to update:

☐ frontend/src/pages/WorkOrder/Details.tsx
  5 imports → aliases

  Line 3:  import { Button } from '../../../components/Button'
        →  import { Button } from '#components/Button'

  Line 4:  import { useAuth } from '../../hooks/useAuth'
        →  import { useAuth } from '#hooks/useAuth'

  Line 8:  import { WorkOrderCard } from '../../../components/cards/WorkOrderCard'
        →  import { WorkOrderCard } from '#components/cards/WorkOrderCard'

  Line 15: import { formatDate } from '../../../core/utils/date'
        →  import { formatDate } from '#core/utils/date'

  Line 22: import { useWorkOrderContext } from '../../contexts/WorkOrderContext'
        →  import { useWorkOrderContext } from '#contexts/WorkOrderContext'


☐ backend/graphql/src/resolvers/workorder.ts
  3 imports → aliases

  Line 8:  import { getLogger } from '../../../common/src/logger'
        →  import { getLogger } from '@mx-common/logger'

  Line 12: import { WorkOrderService } from '../../../src/modules/workorders'
        →  import { WorkOrderService } from '@mx-modules/workorders'

  Line 18: import { validateInput } from '../../../common/src/validation'
        →  import { validateInput } from '@mx-common/validation'
```

**Implementation:**

- Use the Question tool with `multiple: true` to allow selecting multiple files
- Each option label is the file path with replacement count
- Each option description shows the detailed preview of changes
- User can select which files to apply changes to

**If `--preview-only` flag:**

- Show the preview but skip the selection and apply steps
- Exit after displaying the analysis

### Phase 3: Execution

#### 9. Apply Changes to Selected Files

For each file the user selected:

1. Read the current file content
2. For each import to replace (in reverse line order to preserve line numbers):
   - Use the Edit tool to replace the old import with the new alias
   - Preserve exact formatting:
     - Quote style (single vs double quotes)
     - Whitespace and indentation
     - `.js` extensions (leave as-is, don't add or remove)
     - Import syntax (named, default, namespace, dynamic)

**Example Edit:**

```typescript
// oldString
import { Button } from '../../../components/Button'

// newString
import { Button } from '#components/Button'
```

**Preserve formatting:**

```typescript
// Before
import { Button } from "../../../components/Button.js";

// After (preserves double quotes and .js)
import { Button } from "#components/Button.js";
```

#### 10. Report Results

Show a summary of what was changed:

```
✓ Successfully updated 3 files:

  frontend/src/pages/WorkOrder/Details.tsx
    → 5 imports converted to aliases

  backend/graphql/src/resolvers/workorder.ts
    → 3 imports converted to aliases

  dashboard/src/components/Table.tsx
    → 2 imports converted to aliases

Total: 10 imports replaced with path aliases

Skipped 5 files (user deselected)
Skipped 5 imports (safety rules)
```

## Backend Module Import Rules

The backend uses a modular architecture with strict import boundaries. This skill respects those rules:

### Import Rules Summary (from `backend/src/.cursor/BUGBOT.md`)

| Code Location          | Can Import From                         | Using                                                |
| ---------------------- | --------------------------------------- | ---------------------------------------------------- |
| Inside a module        | Code in `backend/` (outside `src/`)     | `@mx-common/*`, `@mx-graphql/*`, `@mx-graphql-types/*` |
| Inside a module        | Code within same module                 | Relative imports (e.g., `../repositories/MyRepo`)    |
| Outside a module       | Module code                             | `@mx-modules/{module-name}` (via index.ts only)      |
| Outside a module       | Code in `backend/` (outside `src/`)     | Relative imports or `@mx-common/*`, etc.             |

### What This Skill Does for Backend

**Within same module:** ✅ **SKIP** - Keep relative imports (required by architecture)

```typescript
// File: backend/src/modules/workorders/services/WorkOrderService.ts
// ✅ CORRECT - keep as relative
import { WorkOrderRepo } from '../repositories/WorkOrderRepository'
```

**Module importing common:** ✅ **REPLACE** - Convert to aliases

```typescript
// File: backend/src/modules/workorders/services/WorkOrderService.ts
// Before
import { logger } from '../../../common/src/logger'
// After
import { logger } from '@mx-common/logger'
```

**Outside module importing module:** ✅ **REPLACE** - Convert to aliases

```typescript
// File: backend/graphql/src/resolvers/workorder.ts
// Before
import { WorkOrderService } from '../../../src/modules/workorders/services/WorkOrderService'
// After
import { WorkOrderService } from '@mx-modules/workorders/services/WorkOrderService'
```

**Cross-module relative import:** ✅ **SKIP** - Architecture violation (flag but don't change)

```typescript
// File: backend/src/modules/workorders/services/WorkOrderService.ts
// ❌ SKIP - violates module boundaries
import { AssetService } from '../../assets/services/AssetService'
// Should use: getModules().assets.service.doSomething(context, params)
```

## Frontend Path Aliases

Frontend uses `#` prefix for internal path aliases:

### Common Frontend Aliases

```json
{
  "#components/*": ["./src/components/*"],
  "#containers/*": ["./src/containers/*"],
  "#contexts/*": ["./src/contexts/*"],
  "#core/*": ["./src/core/*"],
  "#graphql/*": ["./src/graphql/*"],
  "#hooks/*": ["./src/hooks/*"],
  "#images/*": ["./src/images/*"],
  "#modules/*": ["./src/modules/*"],
  "#pantry/*": ["./src/pantry/*"],
  "#redux/*": ["./src/redux/*"],
  "#routes/*": ["./src/routes/*"],
  "#shared-all/*": ["./src/shared-all/*"],
  "#shared-backend-frontend/*": ["./src/shared-backend-frontend/*"],
  "#shared-clients/*": ["./src/shared-clients/*"],
  "#shared-product/*": ["./src/shared-product/*"],
  "#shared-web/*": ["./src/shared-web/*"],
  "#test-utils/*": ["./src/test-utils/*"],
  "#typings/*": ["./src/typings/*"]
}
```

### Frontend Replacement Examples

```typescript
// Before
import { Button } from '../../../components/Button'
import { useAuth } from '../../hooks/useAuth'
import { WorkOrderCard } from '../../../components/cards/WorkOrderCard'
import { colors } from '../../../../pantry/tokens/colors'

// After
import { Button } from '#components/Button'
import { useAuth } from '#hooks/useAuth'
import { WorkOrderCard } from '#components/cards/WorkOrderCard'
import { colors } from '#pantry/tokens/colors'
```

## Domain Services Path Aliases

Domain services (e.g., `domains/search`, `domains/customers`) define minimal local aliases:

### Example: Search Domain

```json
{
  "@mx/search-opensearch-client": ["../../libs/opensearch-client/src/index.ts"],
  "@mx/search-config": ["../../libs/search-config/src/index.ts"]
}
```

**Replacement example:**

```typescript
// File: domains/search/services/graphql-api/src/resolvers/search.ts

// Before
import { createClient } from '../../../../libs/opensearch-client/src/index'
import { getConfig } from '../../../../libs/search-config/src/index'

// After
import { createClient } from '@mx/search-opensearch-client'
import { getConfig } from '@mx/search-config'
```

## tsconfig Path Resolution Details

### Finding the Correct tsconfig

The skill walks up the directory tree from each file to find the nearest `tsconfig.json`:

```
frontend/src/pages/WorkOrder/Details.tsx
  → Check: frontend/src/pages/WorkOrder/tsconfig.json (not found)
  → Check: frontend/src/pages/tsconfig.json (not found)
  → Check: frontend/src/tsconfig.json (not found)
  → Check: frontend/tsconfig.json (FOUND)
```

### Handling `extends`

TypeScript configs can extend other configs. The skill must merge paths from the inheritance chain:

```json
// frontend/tsconfig.json
{
  "extends": "../packages/tsconfig.base.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "#components/*": ["./src/components/*"],
      "#hooks/*": ["./src/hooks/*"]
    }
  }
}

// packages/tsconfig.base.json
{
  "compilerOptions": {
    "paths": {
      "@mx-shared/*": ["../packages/shared/*"]
    }
  }
}

// Merged result for frontend:
{
  "#components/*": "./src/components/*",
  "#hooks/*": "./src/hooks/*",
  "@mx-shared/*": "../packages/shared/*"
}
```

**Resolution algorithm:**

1. Load the file's nearest tsconfig.json
2. If it has an `extends` field:
   - Resolve the extends path (relative to current config)
   - Recursively load the parent config
   - Merge parent paths into current paths
   - Child paths override parent paths for same key
3. Resolve all path patterns relative to the tsconfig's `baseUrl` (default: `.`)

### Handling Comments in tsconfig.json

TypeScript allows comments in `tsconfig.json` (JSON5-style). If needed, strip comments before parsing.

**Simple approach:** Use regex to remove `//` comments and `/* */` blocks before `JSON.parse()`.

**Better approach:** Use `strip-json-comments` package if available, or implement comment stripping.

## Alias Matching Logic

### Wildcard Patterns

Most aliases use wildcard patterns (e.g., `@mx-modules/*`, `#components/*`):

**Matching algorithm:**

1. Strip the `/*` suffix from alias pattern: `@mx-modules/*` → `@mx-modules`
2. Check if resolved path starts with the target directory
3. Calculate the remainder after the target path
4. Construct the replacement: `{aliasPrefix}/{remainder}`

**Example:**

```typescript
// Alias: "@mx-modules/*" → "./src/modules/*"
// File: backend/graphql/src/resolvers/workorder.ts
// Import: import { WO } from '../../../src/modules/workorders/services/WorkOrderService'
// Resolved: backend/src/modules/workorders/services/WorkOrderService
// Target dir: backend/src/modules/
// Remainder: workorders/services/WorkOrderService
// Replacement: @mx-modules/workorders/services/WorkOrderService
```

### Exact Patterns

Some aliases map to exact files (no wildcard):

```json
{
  "@mx-shared/graphql-schema": ["./packages/graphql-schema/src/index.ts"],
  "#routes": ["./src/routes"]
}
```

**Matching algorithm:**

1. Resolve both the import target and alias target to absolute paths
2. Check if they're the same file
3. If yes, replace with the alias (no remainder)

### Preference for Specificity

When multiple aliases could match, prefer the most specific:

**Example:**

```json
{
  "#shared-all/*": ["./src/shared-all/*"],
  "#shared-all/components/*": ["./src/shared-all/components/*"]
}
```

```typescript
// Import: ../../../shared-all/components/Button
// Both aliases match:
//   #shared-all/* → #shared-all/components/Button
//   #shared-all/components/* → #shared-all/components/Button
// ✅ Prefer: #shared-all/components/* (more specific)
```

**Algorithm:** Sort aliases by pattern length (longer = more specific) before matching.

## Parameters

### Command-Line Flags

```bash
# Default: Interactive mode with changed files
/replace-relative-imports

# Preview only (no apply step)
/replace-relative-imports --preview-only

# All files in workspace (not just changed)
/replace-relative-imports --all

# Specific path
/replace-relative-imports src/components/

# Specific path with preview only
/replace-relative-imports src/components/ --preview-only
```

### Parameter Details

**`--preview-only`**
- Show analysis and preview of changes
- Skip the file selection and apply steps
- Useful for understanding what would change

**`--all`**
- Process all TS/JS files in the workspace
- Not just files changed in current branch
- Use with caution on large codebases (can be slow)

**`<path>`**
- Specify a directory or file to process
- Can be absolute or relative to repo root
- Examples: `frontend/src/`, `backend/graphql/`, `src/components/Button.tsx`

## Examples

### Example 1: Frontend Component

**File:** `frontend/src/pages/WorkOrder/Details.tsx`

**Before:**

```typescript
import { Button } from '../../../components/Button';
import { Card } from '../../../components/Card';
import { useAuth } from '../../hooks/useAuth';
import { useWorkOrders } from '../../hooks/useWorkOrders';
import { formatDate } from '../../../core/utils/date';
import { WorkOrderType } from '../../../typings/workorder';
```

**After:**

```typescript
import { Button } from '#components/Button';
import { Card } from '#components/Card';
import { useAuth } from '#hooks/useAuth';
import { useWorkOrders } from '#hooks/useWorkOrders';
import { formatDate } from '#core/utils/date';
import { WorkOrderType } from '#typings/workorder';
```

### Example 2: Backend GraphQL Resolver

**File:** `backend/graphql/src/resolvers/workorder.ts`

**Before:**

```typescript
import { logger } from '../../../common/src/logger';
import { validateInput } from '../../../common/src/validation';
import { WorkOrderService } from '../../../src/modules/workorders';
import { GraphQLContext } from '../context';
```

**After:**

```typescript
import { logger } from '@mx-common/logger';
import { validateInput } from '@mx-common/validation';
import { WorkOrderService } from '@mx-modules/workorders';
import { GraphQLContext } from '../context';
```

**Note:** The last import `../context` stays relative because there's no alias for it (and it's a local file).

### Example 3: Backend Module Service (No Changes)

**File:** `backend/src/modules/workorders/services/WorkOrderService.ts`

**Before:**

```typescript
import { logger } from '../../../../common/src/logger';
import { WorkOrderRepo } from '../repositories/WorkOrderRepository';
import { validateWorkOrder } from '../utils/validation';
import { AssetService } from '../../assets/services/AssetService';
```

**After:**

```typescript
import { logger } from '@mx-common/logger';
import { WorkOrderRepo } from '../repositories/WorkOrderRepository';
import { validateWorkOrder } from '../utils/validation';
import { AssetService } from '../../assets/services/AssetService';
```

**Changes:**
- ✅ Line 1: Replaced with `@mx-common/logger` (module importing common)
- ✅ Line 2: SKIPPED - within-module relative (required by architecture)
- ✅ Line 3: SKIPPED - within-module relative (required by architecture)
- ✅ Line 4: SKIPPED - cross-module relative (architecture violation to flag)

**Skipped imports reported:**

```
backend/src/modules/workorders/services/WorkOrderService.ts:2
  import { WorkOrderRepo } from '../repositories/WorkOrderRepository'
  → Within-module relative import (required by backend architecture)

backend/src/modules/workorders/services/WorkOrderService.ts:3
  import { validateWorkOrder } from '../utils/validation'
  → Within-module relative import (required by backend architecture)

backend/src/modules/workorders/services/WorkOrderService.ts:4
  import { AssetService } from '../../assets/services/AssetService'
  → Cross-module relative import (violates module boundaries)
  ⚠️  Should use: getModules().assets.service.doSomething(context, params)
```

### Example 4: Domain Service

**File:** `domains/search/services/graphql-api/src/resolvers/search.ts`

**Before:**

```typescript
import { createClient } from '../../../../libs/opensearch-client/src/index';
import { getConfig } from '../../../../libs/search-config/src/index';
import { logger } from '../utils/logger';
```

**After:**

```typescript
import { createClient } from '@mx/search-opensearch-client';
import { getConfig } from '@mx/search-config';
import { logger } from '../utils/logger';
```

**Note:** The last import stays relative (no alias for internal utils).

### Example 5: Re-export (Skipped)

**File:** `backend/src/modules/workorders/index.ts`

**Before:**

```typescript
export { WorkOrderService } from './services/WorkOrderService';
export { WorkOrderRepo } from './repositories/WorkOrderRepository';
export * from './types';
```

**After:** (No changes - all are re-exports)

```
backend/src/modules/workorders/index.ts:1
  export { WorkOrderService } from './services/WorkOrderService'
  → Re-export statement (would break runtime module wrapping if converted to alias)

backend/src/modules/workorders/index.ts:2
  export { WorkOrderRepo } from './repositories/WorkOrderRepository'
  → Re-export statement (would break runtime module wrapping if converted to alias)

backend/src/modules/workorders/index.ts:3
  export * from './types'
  → Re-export statement (would break runtime module wrapping if converted to alias)
```

## Error Handling

### tsconfig.json Not Found

If no `tsconfig.json` is found for a file:

```
⚠️  Skipping frontend/src/standalone/script.ts
    Reason: No tsconfig.json found in directory tree
```

Skip the file and continue with others.

### tsconfig.json Parse Error

If a `tsconfig.json` exists but can't be parsed:

```
⚠️  Skipping files in frontend/
    Reason: Failed to parse frontend/tsconfig.json: Unexpected token in JSON at position 42
```

Skip all files that would use this config and continue with others.

### Cannot Resolve Import Target

If a relative import can't be resolved to an absolute path:

```
⚠️  Skipping import in frontend/src/pages/WorkOrder/Details.tsx:12
    import { Unknown } from '../../../nonexistent/file'
    Reason: Cannot resolve import target (file may not exist)
```

Skip this import and continue with others in the same file.

### Multiple tsconfig.json Files

If multiple `tsconfig.json` files exist at different levels, use the nearest one:

```
frontend/tsconfig.json
frontend/src/tsconfig.json  ← Use this for files under frontend/src/
```

### Circular `extends` References

If `tsconfig.json` files have circular `extends` references:

```
⚠️  Skipping files in frontend/
    Reason: Circular extends detected in tsconfig.json chain
```

Track visited configs during resolution to detect cycles.

## Gotchas

### 1. Don't Add `.js` Extensions

**DO NOT add or remove `.js` extensions.** Preserve them exactly as they are in the original import.

```typescript
// Before
import { Button } from '../../../components/Button.js'

// ✅ CORRECT
import { Button } from '#components/Button.js'

// ❌ WRONG
import { Button } from '#components/Button'
```

### 2. Preserve Quote Style

**Preserve the exact quote style** (single vs double) from the original import.

```typescript
// Before (double quotes)
import { Button } from "../../../components/Button"

// ✅ CORRECT
import { Button } from "#components/Button"

// ❌ WRONG
import { Button } from '#components/Button'
```

### 3. Backend Module Boundaries

**Be extra careful with backend module imports.** The backend has strict architectural rules:

- ✅ Within-module: Keep relative
- ✅ Module to common: Convert to `@mx-common/*`
- ✅ Outside to module: Convert to `@mx-modules/*`
- ❌ Cross-module: Flag as violation (don't auto-fix)

### 4. Re-exports Break Runtime

**Never convert re-exports to aliases.** This breaks module wrapping tools used in production.

```typescript
// ❌ NEVER DO THIS
export * from '@mx-modules/workorders'  // Breaks import-in-the-middle

// ✅ CORRECT
export * from '../../../src/modules/workorders'  // But still skip conversion
```

### 5. Workspace Packages vs Path Aliases

**Don't confuse workspace packages with path aliases.** Workspace packages (e.g., `@mx-server/log`) are NOT in tsconfig paths.

```typescript
// ✅ Workspace package (leave as-is)
import { log } from '@mx-server/log'

// ✅ Path alias (can be converted from relative)
import { logger } from '@mx-common/logger'
```

### 6. `baseUrl` Affects Resolution

TypeScript's `baseUrl` affects how paths are resolved. Default is `.` (the tsconfig's directory).

```json
{
  "compilerOptions": {
    "baseUrl": ".",  // Default
    "paths": {
      "#components/*": ["./src/components/*"]  // Relative to baseUrl
    }
  }
}
```

If `baseUrl` is set to `./src`, adjust path resolution accordingly.

### 7. Index Files

When an import points to a directory with an `index.ts` file, preserve the directory reference:

```typescript
// Before
import { WorkOrderService } from '../../../src/modules/workorders/index'

// ✅ CORRECT (preserve /index)
import { WorkOrderService } from '@mx-modules/workorders/index'

// Also acceptable (if original omitted /index)
import { WorkOrderService } from '@mx-modules/workorders'
```

Match the original import style.

### 8. Type-Only Imports

Preserve `type` keyword for type-only imports:

```typescript
// Before
import type { WorkOrderType } from '../../../typings/workorder'

// ✅ CORRECT
import type { WorkOrderType } from '#typings/workorder'

// ❌ WRONG
import { WorkOrderType } from '#typings/workorder'
```

### 9. Side-Effect Imports

Preserve side-effect imports (no bindings):

```typescript
// Before
import '../../../styles/global.css'

// ✅ CORRECT (if alias exists)
import '#styles/global.css'
```

### 10. Dynamic Imports

Handle dynamic imports (promises):

```typescript
// Before
const module = await import('../../../utils/helper')

// ✅ CORRECT
const module = await import('#core/utils/helper')
```

## Key Takeaways

1. **Safety first:** Skip dangerous conversions (re-exports, cross-module, etc.)
2. **Respect backend architecture:** Keep within-module imports relative
3. **Interactive selection:** Let user choose which files to update
4. **Preserve formatting:** Don't change quotes, `.js` extensions, or import style
5. **Only use existing aliases:** Don't add new aliases to tsconfig
6. **Preview before apply:** Always show what will change before making edits
7. **Process changed files:** Focus on current branch changes (or user-specified path)
8. **Report skipped imports:** Help user understand why some imports weren't converted
9. **Flag violations:** Report architecture violations (cross-module imports, etc.)
10. **Use tsconfig as source of truth:** Only convert if alias exists in tsconfig paths
