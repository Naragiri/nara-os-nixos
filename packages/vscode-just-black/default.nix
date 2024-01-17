{ vscode-utils, ... }:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "just-black";
    publisher = "Nur";
    version = "3.1.1";
    sha256 = "sha256-fatJZquCDsLDFGVzBol2D6LIZUbZ6GzqcVEFAwLodW0=";
  };
}