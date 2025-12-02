{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    # Scripts runnable with nix run
    apps = let
      inherit (pkgs.lib) filterAttrs hasSuffix mapAttrsToList genAttrs;

      # App discovery and creation
      scriptsBasedir = ../scripts;
      scriptFiles = builtins.readDir scriptsBasedir;
      scriptNames = mapAttrsToList (name: _: pkgs.lib.removeSuffix ".sh" name) scriptFiles;

      # Build logic for creating executable scripts
      makeExecutable = scriptName: ''
        mkdir -p $out/bin
        cp ${scriptsBasedir}/${scriptName}.sh $out/bin/${scriptName}
        chmod +x $out/bin/${scriptName}
        patchShebangs $out/bin/${scriptName}
      '';

      # Create individual apps
      makeScript = scriptName: {
        type = "app";
        program = "${pkgs.runCommand scriptName {buildInputs = [pkgs.bash];} (makeExecutable scriptName)}/bin/${scriptName}";
        meta = {description = "Run ${scriptName}";};
      };
    in (genAttrs scriptNames makeScript);
  };
}
