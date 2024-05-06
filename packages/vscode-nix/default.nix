{ vscode-utils, ... }:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "Nix";
    publisher = "bbenoist";
    version = "1.0.1";
    sha256 = "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=";
  };
}
