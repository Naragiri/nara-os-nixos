{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  deckyloader-version = "v2.12.0";
  deckyloader = pkgs.fetchurl {
    url =
      "https://github.com/SteamDeckHomebrew/decky-loader/releases/download/${deckyloader-version}/PluginLoader";
    executable = true;
    sha256 = "sha256-T9FdxvOEckHUjWVSZGnsFR6ucNiWOP18Lkmzp4MfMJQ=";
  };
  steamos-runner = pkgs.writeShellApplication {
    name = "steamos-runner";
    runtimeInputs = with pkgs; [
      gamescope
      mangohud
      ibus
      coreutils
      killall
      inotify-tools
    ];
    text = let
      steam-runner = pkgs.writeScript "steam-runner" ''
        if command -v ibus-daemon > /dev/null; then
          ibus-daemon -d -r --panel=disable --emoji-extension=disable &
        fi

        if command -v mangoapp > /dev/null; then
          mangoapp > "${cfg.steamos.logsDir}/mangoapp-stdout.log" 2>&1 &
        fi

        steam -gamepadui -steamos3 -steampal -steamdeck > "${cfg.steamos.logsDir}/steam-stdout.log" 2>&1
      '';

      plugin-patcher = pkgs.writeScript "plugin-patcher" ''
        tmpdir="$(mktemp -d)"
        trap 'rm -rf "$tmpdir"' EXIT

        patch_plug() {
          if [[ "$(file --dereference --mime "$@")" != *"binary" ]]; then
            # do not use -i because of the inotifywait
            local tmp; tmp="$(mktemp)"
            sed "s,/home/deck/homebrew,$HOME/.steam/deckyloader,g" "$@" > "$tmp"
            sed -i "s,/home/deck/,$HOME/,g" "$tmp"
            if ! cmp --silent "$tmp" "$@"; then
              printf -- "patching '%s'\n" "$@"
              cp -f "$tmp" "$@"
            fi
            rm -f "$tmp"
          fi
        }

        # patch badly written plugins
        (grep -rlF '/home/deck/' /home/${config.nos.user.name}/.steam/deckyloader/plugins || true) | while read -r path; do patch_plug "$path"; done

        mkfifo "$tmpdir"/inotify.fifo
        inotifywait --monitor -e create -e modify -e attrib -qr /home/${config.nos.user.name}/.steam/deckyloader --exclude /home/${config.nos.user.name}/.steam/deckyloader/services -o "$tmpdir"/inotify.fifo &

        # has to be a copy, symlink makes PluginLoader look up files from wrong directory
        rm -f /home/${config.nos.user.name}/.steam/deckyloader/services/PluginLoader
        cp -f ${deckyloader} /home/${config.nos.user.name}/.steam/deckyloader/services/PluginLoader
        (cd /home/${config.nos.user.name}/.steam/deckyloader/services; steam-run ./PluginLoader &> PluginLoader.log &)

        set +e
        while read -r dir event base; do
          file="$dir$base"
          if [[ "$event" == "ATTRIB"* ]]; then
            if [[ -d "$file" ]]; then
              [[ "$(stat -c '%a' "$file")" != "755" ]] && chmod -v 755 "$file"
            else
              [[ "$(stat -c '%a' "$file")" != "644" ]] && chmod -v 644 "$file"
            fi
          elif [[ -f "$file" ]]; then
            patch_plug "$file"
          fi
        done &> /home/${config.nos.user.name}/.steam/deckyloader/services/inotifywait.log < "$tmpdir"/inotify.fifo
      '';
    in ''
      export XDG_SESSION_TYPE=x11
      export LIBSEAT_BACKEND="logind"
      export XKB_DEFAULT_LAYOUT="${config.console.keyMap}"

      TMP="$(mktemp -d)"
      trap 'rm -rf "$TMP"' EXIT

      export INTEL_DEBUG=norbc
      export mesa_glthread=true
      export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
      export SRT_URLOPEN_PREFER_STEAM=1
      export STEAM_USE_DYNAMIC_VRS=1

      export STEAM_GAMESCOPE_HAS_TEARING_SUPPORT=1
      export STEAM_GAMESCOPE_TEARING_SUPPORTED=1
      export STEAM_ENABLE_VOLUME_HANDLER=1
      export STEAM_GAMESCOPE_HDR_SUPPORTED=1
      export STEAM_GAMESCOPE_COLOR_TOYS=1
      export STEAM_GAMESCOPE_NIS_SUPPORTED=1
      export STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT=1
      export STEAM_MULTIPLE_XWAYLANDS=1
      export STEAM_USE_MANGOAPP=1
      export STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND=1
      export STEAM_MANGOAPP_PRESETS_SUPPORTED=1
      export STEAM_MANGOAPP_HORIZONTAL_SUPPORTED=1

      export QT_IM_MODULE=steam
      export GTK_IM_MODULE=Steam

      export RADV_FORCE_VRS_CONFIG_FILE=$TMP/radv_vrs.XXXXXXXX
      mkdir -p "$(dirname "$RADV_FORCE_VRS_CONFIG_FILE")"
      echo "1x1" > "$RADV_FORCE_VRS_CONFIG_FILE"

      export MANGOHUD_CONFIGFILE=$TMP/mangohud.XXXXXXXX
      mkdir -p "$(dirname "$MANGOHUD_CONFIGFILE")"
      echo "no_display" > "$MANGOHUD_CONFIGFILE"

      ulimit -n 524288

      mkdir -p /home/${config.nos.user.name}/.steam/deckyloader/services
      mkdir -p /home/${config.nos.user.name}/.steam/deckyloader/plugins
      echo "${deckyloader-version}" > /home/${config.nos.user.name}/.steam/deckyloader/services/.loader.version
      touch /home/${config.nos.user.name}/.steam/steam/.cef-enable-remote-debugging
      chmod -R u=rwX,go=rX /home/${config.nos.user.name}/.steam/deckyloader

      bash ${plugin-patcher} &

      if [ ! -d "${cfg.steamos.logsDir}" ]; then
        mkdir -p "${cfg.steamos.logsDir}"
      fi

      GAMESCOPE_COMMAND="gamescope -e \
        --prefer-output $GAMESCOPE_PREFERRED_OUTPUT \
        --hdr-enabled --hdr-itm-enable \
        -h $GAMESCOPE_INTERNAL_HEIGHT -w $GAMESCOPE_INTERNAL_WIDTH \
        -H $GAMESCOPE_EXTERNAL_HEIGHT -W $GAMESCOPE_EXTERNAL_WIDTH \
        -r $GAMESCOPE_REFRESH_RATE \
        -F fsr -b -f --adaptive-sync \
        --expose-wayland --xwayland-count 2 \
        --steam -- ${steam-runner}"

      echo "$GAMESCOPE_COMMAND" > "${cfg.steamos.logsDir}/gamescope-command.log"
      $GAMESCOPE_COMMAND > "${cfg.steamos.logsDir}/gamescope-stdout.log" 2>&1

      pgrep '^PluginLoader' | while read -r pid; do kill -SIGKILL "$pid" || true; done
      killall mangoapp inotifywait .ibus-daemon-wrapper
    '';
  };

  steamos-pc = pkgs.writeShellScriptBin "steamos-pc" ''
    export GAMESCOPE_PREFERRED_OUTPUT=DP-1
    export GAMESCOPE_INTERNAL_WIDTH=1920
    export GAMESCOPE_INTERNAL_HEIGHT=1080
    export GAMESCOPE_EXTERNAL_WIDTH=2560
    export GAMESCOPE_EXTERNAL_HEIGHT=1440
    export GAMESCOPE_REFRESH_RATE=144
    ${steamos-runner}/bin/steamos-runner
  '';

  steamos-tv = pkgs.writeShellScriptBin "steamos-tv" ''
    export GAMESCOPE_PREFERRED_OUTPUT=HDMI-A-1
    export GAMESCOPE_INTERNAL_WIDTH=1920
    export GAMESCOPE_INTERNAL_HEIGHT=1080
    export GAMESCOPE_EXTERNAL_WIDTH=3840
    export GAMESCOPE_EXTERNAL_HEIGHT=2160
    export GAMESCOPE_REFRESH_RATE=60
    ${steamos-runner}/bin/steamos-runner
  '';

  consoleSession =
    (pkgs.writeTextDir "share/wayland-sessions/steamos.desktop" ''
      [Desktop Entry]
      Name=SteamOS
      Comment=SteamOS Console Session
      Exec=${steamos-tv}/bin/steamos-tv
      Type=Application
    '').overrideAttrs (_: { passthru.providedSessions = [ "steamos" ]; });

  cfg = config.nos.apps.steam;
in {
  options.nos.apps.steam = with types; {
    enable = mkEnableOption "Enable steam.";
    steamos = {
      enable = mkEnableOption "Enable steamos with console session.";
      deckyLoader.enable =
        mkEnableOption "Enable decky loader to load plugins.";
      logsDir = mkOpt path "/home/${config.nos.user.name}/.config/steam-os"
        "The directory to save steam-os logs to.";
    };
  };

  config = mkIf cfg.enable {
    hardware.xone.enable = true;
    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
      # capSysNice = true;
    };

    programs.steam = {
      enable = true;
      package = (pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            # steamdeck first boot wizard skip
            (writeScriptBin "steamos-polkit-helpers/steamos-update" ''
              #!${pkgs.stdenv.shell}
              exit 7
            '')
            # switch to desktop
            (writeScriptBin "steamos-session-select" ''
              #!${pkgs.stdenv.shell}
              kill $PPID
            '')
          ];
      });
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs;
      [ mangohud protontricks winetricks ] ++ optionals (cfg.steamos.enable) [
        (makeDesktopItem {
          name = "Steam (Gamepad UI)";
          desktopName = "Steam (Gamepad UI)";
          genericName = "Application for managing and playing games on Steam.";
          categories = [ "Network" "FileTransfer" "Game" ];
          type = "Application";
          icon = "steam";
          exec = "${getExe steamos-pc}";
          terminal = false;
        })
        steamos-pc
        steamos-tv
      ];

    services.displayManager.sessionPackages =
      mkIf cfg.steamos.enable [ consoleSession ];
  };
}
