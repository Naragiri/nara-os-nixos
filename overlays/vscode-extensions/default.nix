_: prev: {
  vscode-extensions =
    let
      mkVscodeExtensionFromSource =
        publisher: ext:
        let
          source = (prev.callPackages ./generated.nix { }).${ext};
          name = "${publisher}-${source.pname}-${source.version}";
        in
        prev.vscode-utils.buildVscodeExtension {
          inherit name;
          inherit (source) version src;
          vscodeExtPublisher = publisher;
          vscodeExtName = ext;
          vscodeExtUniqueId = "${publisher}.${ext}";
        };
    in
    prev.vscode-extensions
    // {
      jnoortheen.nix-ide = (mkVscodeExtensionFromSource "jnoortheen" "nix-ide") // {
        inherit (prev.vscode-extensions.jnoortheen.nix-ide) meta;
      };

      tomblind.local-lua-debugger = mkVscodeExtensionFromSource "tomblind" "local-lua-debugger-vscode";

      lukinco.lukin-vscode-theme = mkVscodeExtensionFromSource "lukinco" "lukin-vscode-theme";

      lefd.sweet-dracula-monokai = mkVscodeExtensionFromSource "lefd" "sweetdracula-monokai";

      Nur.just-black = mkVscodeExtensionFromSource "Nur" "just-black";
    };
}
