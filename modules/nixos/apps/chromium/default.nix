{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  cfg = config.nos.apps.chromium;
  default-extensions = let
    createChromiumExtensionFor = browserVersion:
      { id, sha256, version }: {
        inherit id;
        crxPath = builtins.fetchurl {
          url =
            "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
          name = "${id}.crx";
          inherit sha256;
        };
        inherit version;
      };
    createChromiumExtension =
      createChromiumExtensionFor (lib.versions.major cfg.package.version);
  in [
    (createChromiumExtension {
      # ublock origin
      id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      sha256 = "sha256:0fsygwn7rff79405fr96j89i9fx7w8dl3ix9045ymgm0mf3747pd";
      version = "1.57.0";
    })
    (createChromiumExtension {
      # dark reader
      id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      sha256 = "sha256:0dgia7x1bcds3jivzin668n4cmhgk9k34j4zj36n3k6ghmsrp7n3";
      version = "4.9.85";
    })
    (createChromiumExtension {
      # bitwarden
      id = "nngceckbapebfimnlniiiahkandclblb";
      sha256 = "sha256:0ghyvp00wj19ixn0q8qyzsbgaif84kqqqjyjs8blp6rq12yp04pn";
      version = "2024.4.2";
    })
    (createChromiumExtension {
      # user agent switcher and manager
      id = "bhchdcejhohfmigjafbampogmaanbfkg";
      sha256 = "sha256:10j4hq8npdrvmlry8j8k1libxf7r6r2195mf6bsd2kfxdhxfx8q8";
      version = "0.5.0";
    })
  ];
in {
  options.nos.apps.chromium = with types; {
    enable = mkEnableOption "Enable chromium.";
    extensions =
      mkOpt (listOf attrs) default-extensions "Extensions to add to chromium.";
    package = mkOpt package pkgs.brave "The chromium package.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.chromium = enabled // {
      inherit (cfg) extensions package;
    };
  };
}
