# Temporary workarounds for broken packages in the pinned nixpkgs. Remove each once upstream is fixed.
final: prev: {
  # solaar 1.1.19: test_show needs a D-Bus session (machine-id), which the build sandbox lacks.
  solaar = prev.solaar.overridePythonAttrs (old: {
    disabledTests = (old.disabledTests or [ ]) ++ [ "test_show" ];
  });
}
