{ vscode-utils, ... }:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "local-lua-debugger-vscode";
    publisher = "tomblind";
    version = "0.3.3";
    sha256 = "7uZHbhOa/GT9F7+xikaxuQXIGzre1q1uWTWaTJhi2UA=";
  };
}
