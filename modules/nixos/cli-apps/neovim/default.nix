{ lib, config, pkgs, inputs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.cli-apps.neovim;
in {
  imports = with inputs; [ nixvim.nixosModules.nixvim ];

  options.nos.cli-apps.neovim = with types; {
    enable = mkEnableOption "Enable neovim.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ neovim ];

    programs.nixvim = enabled // {
      globals = { mapleader = " "; };
      options = {
        autoindent = true;
        cursorline = true;
        tabstop = 2;
        linebreak = true;
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        wrap = true;
      };
      plugins = {
        lualine = enabled;
        lsp = enabled // { servers = { nixd = enabled; }; };
        nvim-cmp = enabled // {
          autoEnableSources = true;
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true})";
            "<Tab>" = {
              action = ''
                								function(fallback)
                									if cmp.visible() then
                										cmp.select_next_item()
                									else
                										fallback()
                								  end
                                end
                							'';
              modes = [ "i" "s" ];
            };
          };
          sources =
            [ { name = "nvim_lsp"; } { name = "path"; } { name = "buffer"; } ];
        };
        telescope = enabled // {
          keymaps = {
            "<C-p>" = "find_files";
            "<leader>fg" = "live_grep";
          };
        };
      };
    };
  };
}
