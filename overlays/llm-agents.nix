# Expose numtide/llm-agents.nix as pkgs.llm-agents (claude-code, codex, ...), updated daily upstream.
# Uses the flake's own pinned nixpkgs so binaries come from cache.numtide.com instead of building here.
{ llm-agents }:
final: prev: {
  llm-agents = llm-agents.packages.${prev.stdenv.hostPlatform.system};
}
