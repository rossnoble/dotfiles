#!/usr/bin/env ruby

# Sync obsidian configs through symlinks
# TODO: Rewrite using bash and add CLI prompts

DOTFILES = File.expand_path("~/Code/dotfiles/obsidian")
CONFIGS_TO_LINK = %w[appearance.json hotkeys.json core-plugins.json]

def link_configs(vault_path)
  obsidian_dir = File.join(vault_path, ".obsidian")
  
  CONFIGS_TO_LINK.each do |config|
    source = File.join(DOTFILES, config)
    target = File.join(obsidian_dir, config)
    
    if File.symlink?(target)
      puts "✓ #{config} already linked"
    else
      File.delete(target) if File.exist?(target)
      File.symlink(source, target)
      puts "→ Linked #{config}"
    end
  end
end

# Usage: ruby sync-obsidian-config.rb ~/Documents/WorkVault
link_configs(ARGV[0])
