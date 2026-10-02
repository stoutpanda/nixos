# AI coding agents from numtide/llm-agents.nix (pkgs.llm-agents, see overlays/llm-agents.nix).
# Bump with: nix flake update llm-agents
{ pkgs, ... }:
{
  home.packages = with pkgs.llm-agents; [
    claude-code
    codex
    gemini-cli
    opencode
    qwen-code
    pi
    hermes-agent
    hermes-hud
    hermes-desktop
    paperclip
    t3code
    dsh
  ];
}
