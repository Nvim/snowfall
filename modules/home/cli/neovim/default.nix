{
  pkgs,
  lib,
  config,
  system,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.cli.neovim;
in
{
  options.cli.neovim = {
    enable = mkOpt types.bool false "Enable Neovim Packages";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${system}.default;
      extraPackages = with pkgs; [

        fzf
        xclip
        tree-sitter

        # Language Support:
        yarn
        php
        php83Packages.composer
        python311
        python311Packages.pip
        go
        gotools # goimports

        # LSP:
        clang-tools # for clangd
        cmake-language-server
        lua-language-server
        nixd
        vscode-langservers-extracted
        emmet-language-server
        ruff-lsp
        pyright
        vscode-extensions.vue.volar
        nodePackages.typescript-language-server
        nodePackages.intelephense
        tailwindcss-language-server
        bash-language-server
        gopls
        # npm install -g @vtsls/language-server
        # npm install -g vscode-langservers-extracted

        # Lint:
        # cmake-lint
        hadolint
        php83Packages.php-codesniffer # PHPCS
        golangci-lint

        # Format:
        nixfmt-rfc-style
        prettierd
        cmake-format
        stylua
        isort
        black
        shfmt
        gofumpt

        # DAP:
        delve

        # Misc:
        gomodifytags
        impl
      ];
    };
  };
}
