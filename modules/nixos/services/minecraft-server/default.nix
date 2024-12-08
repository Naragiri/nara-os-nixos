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
    mapAttrsToList
    ;
  cfg = config.nos.services.minecraft-server;

  minecraftUUID =
    lib.types.strMatching "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
    // {
      description = "Minecraft UUID";
    };
in
{
  options.nos.services.minecraft-server = with types; {
    enable = mkEnableOption "Enable minecraft server service.";
    dataDir = mkOption {
      default = "/srv/minecraft-server/";
      description = "The path to store the server files.";
      type = types.path;
    };
    package = mkOption {
      default = pkgs.minecraft-server;
      description = "The package to use for the server.";
      type = types.package;
    };
    serverProperties = {
      port = mkOption {
        default = 25565;
        description = "The port to accept connections on.";
        type = types.port;
      };
      motd = mkOption {
        default = "A Minecraft Server. Powered by NixOS";
        description = "The server message of the day.";
        type = types.port;
      };
    };
    username = mkOption {
      default = "minecraft-server";
      description = "The user who runs the server service.";
      type = types.str;
    };
    whitelist = mkOption {
      default = { };
      description = "The whitelisted player by UUID.";
      type = types.attrsOf minecraftUUID;
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.username} = {
      description = "Minecraft server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "${cfg.username}";
    };

    users.groups.${cfg.username} = { };

    systemd.sockets.minecraft-server = {
      bindsTo = [ "minecraft-server.service" ];
      socketConfig = {
        ListenFIFO = "/run/minecraft-server.stdin";
        SocketMode = "0660";
        SocketUser = "${cfg.username}";
        SocketGroup = "${cfg.username}";
        RemoveOnStop = true;
        FlushPending = true;
      };
    };

    systemd.services.minecraft-server = {
      description = "Minecraft Server Service";
      wantedBy = [ "multi-user.target" ];
      requires = [ "minecraft-server.socket" ];
      after = [
        "network.target"
        "minecraft-server.socket"
      ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/minecraft-server";
        # ExecStop = "${stopScript} $MAINPID";
        Restart = "always";
        User = "${cfg.username}";
        WorkingDirectory = cfg.dataDir;

        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };

      preStart =
        let
          serverPropertiesFile = pkgs.writeText "server.properties" ''
            # server.properties managed by NixOS configuration
            enable-jmx-monitoring=false
            rcon.port=25575
            level-seed=
            gamemode=survival
            enable-command-block=false
            enable-query=false
            generator-settings={}
            enforce-secure-profile=true
            level-name=world
            motd=A Minecraft Server
            query.port=25565
            pvp=true
            generate-structures=true
            max-chained-neighbor-updates=1000000
            difficulty=easy
            network-compression-threshold=256
            max-tick-time=60000
            require-resource-pack=false
            use-native-transport=true
            max-players=20
            online-mode=true
            enable-status=true
            allow-flight=false
            initial-disabled-packs=
            broadcast-rcon-to-ops=true
            view-distance=10
            server-ip=
            resource-pack-prompt=
            allow-nether=true
            server-port=25565
            enable-rcon=false
            sync-chunk-writes=true
            op-permission-level=4
            prevent-proxy-connections=false
            hide-online-players=false
            resource-pack=
            entity-broadcast-range-percentage=100
            simulation-distance=10
            rcon.password=
            player-idle-timeout=0
            force-gamemode=false
            rate-limit=0
            hardcore=false
            white-list=false
            broadcast-console-to-ops=true
            spawn-npcs=true
            spawn-animals=true
            log-ips=true
            function-permission-level=2
            initial-enabled-packs=vanilla
            level-type=minecraft\:normal
            text-filtering-config=
            spawn-monsters=true
            enforce-whitelist=false
            spawn-protection=16
            resource-pack-sha1=
            max-world-size=29999984
          '';

          whitelistFile = pkgs.writeText "whitelist.json" (
            builtins.toJSON (
              mapAttrsToList (n: v: {
                name = n;
                uuid = v;
              }) cfg.whitelist
            )
          );

          eulaFile = builtins.toFile "eula.txt" ''
            # eula.txt managed by NixOS Configuration
            eula=true
          '';
        in
        ''
          ln -sf ${eulaFile} eula.txt
          ln -sf ${whitelistFile} whitelist.json
          cp -f ${serverPropertiesFile} server.properties
        '';
    };
  };
}
