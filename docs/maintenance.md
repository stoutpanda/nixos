# Maintenance

## Checking and updating

With Nix installed, evaluate both hosts before switching. Run the following block in Bash (`bash` from fish). Before a first installation or a kernel/driver update, also build the target system; evaluation alone does not compile packages or test activation and hardware.

```sh
for host in voidreliquary whitedwarf; do
  nix eval --no-write-lock-file --raw ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath" || exit
done
nix build --no-write-lock-file .#nixosConfigurations.voidreliquary.config.system.build.toplevel
```

For dependency updates, start with a clean checkout, run `nix flake update`, review `git diff -- flake.lock`, then evaluate both hosts and build the one you will switch. Commit the lockfile with any compatibility fixes. Keep `system.stateVersion` and `home.stateVersion` at `26.05`; they are compatibility settings, not the channel version to bump on each upgrade.

AI agents (`home/ai.nix`) update daily upstream. Bump just them with `nix flake update llm-agents`; the rest of the system stays put.

## Checking a change without a NixOS machine

```sh
docker run --rm -v "$PWD":/src:ro -w /src nixos/nix sh -c \
  'set -e
   git config --global --add safe.directory /src
   for host in voidreliquary whitedwarf; do
     nix --extra-experimental-features "nix-command flakes" \
       eval --no-write-lock-file --raw ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath"
   done'
```

## Rolling back

Pick an older generation from the boot menu, or run `sudo nixos-rebuild switch --rollback`. This restores system configuration and packages only, not documents or application data; see the backup section of [installing-a-new-host.md](installing-a-new-host.md#0-back-up-the-current-install).
