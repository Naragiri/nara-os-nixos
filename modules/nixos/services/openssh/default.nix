{
  lib,
  config,
  format ? "",
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.nos) enabled;
  cfg = config.nos.services.openssh;

  defaultKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCKbp5dwNYB/2rkzM17D8EXrm2VLCkwin38E8ErUgqoM0BrLPlpe5qafFydvaMrdPA8TfRuRuO6jdrkuKkF9H4+gS7UxZCdNWywRypQPeFm6NXBJxQssWPt0kY9x5wp+j3d7Tqf/MXjjII+XESCEbp3Qh8tn2ddk74qsYj2M6ZviHWx3E3+Q6Jar++ZkPJYbpSE2DwQiU56x+12NdbxGyvieTvPXzsUYiLbe+Q+jmwbgk7CSHWNymBDIFlRU9osyBw1ecDOxWFWuE56HFP+H2Nq75Y9tIjgNHR1oviFLNZFGk46Ihl2E/IzmloRzCI7EQHRVs6K2zS1qm9O+taeYyi/P7pE43jlkEfcNobwEY/zfgwWqVetolTP5ucQ2KLe3yU+qg6Lk6PIG9GN5OpwA19pAt1NdMFNi4Gv9mJagE8i/wdL82wJpDM0FOJHGnaxdNz4AfwXAUIhaoK6fLE86qzj/AyogYXcBI1en13/fsSxft8jkOVIinO2Ts/BSb/gNlbtv4v3EoKcaQaue0snkrY+uGJmyb4Og3MvQNNelbq/V1h/rbtEKyXN/nJXNRiytgyIKQbyZ3gh6//USzurfchRTqzvPLWeaOLujrM6q79hG0X9Yw3uJmGXh9sXJwXbUn6eSqpdKkljx+wU/82y9368RYbOt0mq64LXvMs/rTV0pQ==";
in
{
  options.nos.services.openssh = {
    enable = mkEnableOption "Enable openssh.";
    authorizedKeys = mkOption {
      default = [ defaultKey ];
      description = "The list of authorized ssh keys.";
      type = types.listOf types.str;
    };
    port = mkOption {
      default = 22;
      description = "The port to listen on for ssh.";
      type = types.port;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = enabled // {
      settings = {
        PermitRootLogin = if format == "install-iso" then "yes" else "no";
        PasswordAuthentication = false;
      };

      ports = [ cfg.port ];
    };

    programs.ssh = {
      extraConfig = ''
        Host *
          HostKeyAlgorithms +ssh-rsa
      '';
      startAgent = true;
    };

    users.users = {
      root.openssh.authorizedKeys.keys = mkIf (format == "install-iso") [ defaultKey ];
      ${config.nos.user.name}.openssh.authorizedKeys.keys = [ defaultKey ];
    };
  };
}
