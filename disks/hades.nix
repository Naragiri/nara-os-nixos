{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "esp";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "uid=0" "gid=0" "fmask=0077" "dmask=0077" ];
              };
            };
            swap = {
              name = "swap";
              size = "8G";
              type = "8200";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              name = "root";
              size = "100%";
              type = "8300";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [ "noatime" ];
                extraArgs = [ "-O casefold -E encoding_flags=strict" ];
              };
            };
            # root = {
            #   name = "root";
            #   size = "100%";
            #   type = "8309";
            #   content = {
            #     type = "luks";
            #     name = "crypted";
            #     settings.allowDiscards = true;
            #     passwordFile = "/tmp/secret.key";
            #     content = {
            #       type = "filesystem";
            #       format = "ext4";
            #       mountpoint = "/";
            #       mountOptions = [ "noatime" ];
            #     };
            #   };
            # };
          };
        };
      };
    };
  };
}