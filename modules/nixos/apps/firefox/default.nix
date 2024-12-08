{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.nos) recursiveMergeAttrs enabled;

  cfg = config.nos.apps.firefox;
in
{
  options.nos.apps.firefox = {
    enable = mkEnableOption "Enable firefox with custom config.";
    makeDefaultBrowser = mkEnableOption "Set as the default browser (mimeapps).";
    package = mkOption {
      default = pkgs.firefox;
      description = "The firefox browser package.";
      type = types.package;
    };
    extraPolicies = mkOption {
      default = { };
      description = "Extra policies for firefox.";
      type = types.attrs;
    };
    extraSettings = mkOption {
      default = { };
      description = "Extra config for the user profile.";
      type = types.attrs;
    };
    userChrome = mkOption {
      default = "\n";
      description = "The css to apply to the user chrome.";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      pkgs.nos.betterfox
    ];

    nos.home.extraOptions = {
      programs.firefox = enabled // {
        policies = recursiveMergeAttrs [
          {
            # Telemetry
            DisableFirefoxStudies = true;
            DisableTelemetry = true;
            DisablePocket = true;

            FirefoxHome = {
              Search = true;
              TopSites = true;
              SponsoredTopSites = false;
              Highlights = true;
              Pocket = false;
              SponsoredPocket = false;
              Snippets = false;
              Locked = true;
            };

            FirefoxSuggest = {
              WebSuggestions = false;
              SponsoredSuggestions = false;
              ImproveSuggest = false;
            };

            # Privacy
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
              EmailTracking = true;
            };

            # NixOS
            AppAutoUpdate = false;
            ManualAppUpdateOnly = false;
            DisableSetDesktopBackground = true;

            # Preference
            DontCheckDefaultBrowser = true;
            DefaultDownloadDirectory = "/home/${config.nos.user.name}/Downloads";
            OfferToSaveLogins = false;
            PromptForDownloadLocation = true;

            UserMessaging = {
              ExtensionRecommendations = false;
              FeatureRecommendations = false;
              Locked = true;
              MoreFromMozilla = false;
              SkipOnboarding = true;
              UrlbarInterventions = false;
              WhatsNew = false;
            };

            UseSystemPrintDialog = true;
          }
          cfg.extraPolicies
        ];
        profiles.${config.nos.user.name} = {
          settings = recursiveMergeAttrs [
            {
              "browser.aboutConfig.showWarning" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.newtabpage.activity-stream.system.showWeather" = false;
              "browser.safebrowsing.downloads.enabled" = true;
              "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = true;
              "browser.safebrowsing.downloads.remote.block_uncommon" = true;
              "browser.safebrowsing.malware.enabled" = true;
              "browser.safebrowsing.phishing.enabled" = true;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.tabs.loadInBackground" = false;
              "browser.tabs.warnOnClose" = true;
              "dom.security.https_only_mode" = true;
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "font.name.serif.x-western" = "JetBrainsMono Nerd Font";
              "geo.provider.use_geoclue" = false;
              "layout.spellcheckDefault" = 0;
              "media.eme.enabled" = true;
              "media.autoplay.default" = 5;
              "permissions.default.camera" = 2;
              "permissions.default.desktop-notification" = 2;
              "permissions.default.microphone" = 2;
              "permissions.default.xr" = 2;
              "privacy.donottrackheader.enabled" = true;
              "privacy.globalprivacycontrol.enabled" = true;
              "signon.management.page.breach-alerts.enabled" = false;
            }
            cfg.extraSettings
          ];
          inherit (cfg) userChrome;
          inherit (config.nos.user) name;
          id = 0;
          bookmarks = [
            {
              name = "Nix";
              toolbar = true;
              bookmarks = [
                {
                  name = "NixOS Homepage";
                  url = "https://nixos.org/";
                }
                {
                  name = "Home Manager Options";
                  url = "https://home-manager-options.extranix.com";
                }
                {
                  name = "NixOS Wiki";
                  url = "https://nixos.wiki/";
                }
              ];
            }
          ];
          search = {
            default = "SearXNG";
            force = true;
            engines = {
              "SearXNG" = {
                urls = [
                  {
                    template = "https://searx.be/?q={searchTerms}";
                  }
                ];
                iconUpdateURL = "https://searx.be/static/themes/simple/img/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
              };
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };
              "Home Manager Options" = {
                urls = [
                  {
                    template = "https://home-manager-options.extranix.com";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                      {
                        name = "release";
                        value = "master"; # unstable
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@hm" ];
              };
              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://nixos.wiki/index.php?search={searchTerms}";
                  }
                ];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = [ "@nw" ];
              };
              "Google".metaData.hidden = true;
              "Bing".metaData.hidden = true;
              "Wikipedia (en)".metaData.hidden = true;
            };
          };
        };
      };
      xdg.mimeApps.defaultApplications = mkIf cfg.makeDefaultBrowser {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
      };
    };
  };
}
