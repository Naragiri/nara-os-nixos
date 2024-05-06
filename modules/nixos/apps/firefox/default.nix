{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  cfg = config.nos.apps.firefox;
  defaultUserSettings = {
    "app.shield.optoutstudies.enabled" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.aboutWelcome.enabled" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" =
      false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "browser.safebrowsing.malware.enabled" = false;
    "browser.safebrowsing.phishing.enabled" = false;
    "browser.search.serpEventTelemetry.enabled" = false;
    "browser.startup.page" = 3;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "dom.forms.autocomplete.formautofill" = false;
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;
    "dom.security.unexpected_system_load_telemetry_enabled" = false;
    "experiments.activeExperiment" = false;
    "experiments.enabled" = false;
    "experiments.supported" = false;
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.pocket.enabled" = false;
    "extensions.pocket.api" = "";
    "extensions.pocket.oAuthConsumerKey" = "";
    "extensions.pocket.showHome" = false;
    "extensions.pocket.site" = "";
    "media.autoplay.default" = 5;
    "network.allow-experiments" = false;
    "network.trr.confirmation_telemetry_enabled" = false;
    "permissions.default.camera" = 2;
    "permissions.default.desktop-notification" = 2;
    "permissions.default.geo" = 2;
    "permissions.default.microphone" = 2;
    "permissions.default.xr" = 2;
    "privacy.clearOnShutdown.cookies" = true;
    "privacy.clearOnShutdown.downloads" = false;
    "privacy.clearOnShutdown.formdata" = true;
    "privacy.clearOnShutdown.history" = false;
    "privacy.clearOnShutdown.sessions" = false;
    "privacy.donottrackheader.enabled" = true;
    "privacy.fingerprintingProtection" = true;
    "privacy.history.custom" = true;
    "privacy.partition.network_state.ocsp_cache" = true;
    # "privacy.resistFingerprinting" = true; Only enable if you're not using CanvasBlocker.
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "security.app_menu.recordEventTelemetry" = false;
    "security.certerrors.recordEventTelemetry" = false;
    "security.protectionspopup.recordEventTelemetry" = false;
    "signon.autofillForms" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.hybridContent.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.pioneer-new-studies-available" = false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
  };
in {
  options.nos.apps.firefox = with types; {
    enable = mkEnableOption "Enable firefox with custom config.";
    settings =
      mkOpt attrs defaultUserSettings "Settings to apply to the user profile.";
    userChrome = mkOpt str "" "Extra config for the user chrome file.";
    extraConfig = mkOpt str "" "Extra config for the user profile.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ firefox ];

    nos.home.extraOptions.programs.firefox = enabled // {
      policies = {
        DefaultDownloadDirectory = "/home/${config.nos.user.name}/Downloads";
        DisablePocket = true;
        DisableTelemetry = true;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
        };
        OfferToSaveLogins = false;
      };
      profiles.${config.nos.user.name} = {
        inherit (cfg) extraConfig userChrome settings;
        name = config.nos.user.name;
        id = 0;
        bookmarks = [{
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
        }];
        search = {
          default = "DuckDuckGo";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "Home Manager Options" = {
              urls = [{
                template = "https://home-manager-options.extranix.com";
                params = [{
                  name = "query";
                  value = "{searchTerms}";
                }];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
            };
            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@nw" ];
            };
          };
        };
      };
    };
  };
}
