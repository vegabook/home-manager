{ config, pkgs, lib, ... }:

let
  fromGitHub = rev: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = rev;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      rev = rev;
    };
  };
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mmai";
  home.homeDirectory = "/Users/mmai";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  programs.home-manager.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    rclone
    tree
    ack
    iosevka
    chafa # sixel viewer
    fuse
    neovim
    nodejs_21
    (nerdfonts.override { fonts = [ "FantasqueSansMono" "3270" "HeavyData"]; })

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];           
  programs.git = {
    enable = true;
    userName = "vegabook";
    userEmail = "thomas@scendance.fr";
  };

  programs.tmux = {
    enable = true;
  };


  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ls = "ls -alG";
      vim = "nvim";
      zlj = "zellij";
      sd="cd ~ && cd \$(find * -type d | fzf)";
    };
    initExtra = ''
      make_superscript () { sed 'y/0123456789/⁰¹²³⁴⁵⁶⁷⁸⁹/' <<< $SHLVL; };
      direnv_yes () { env | grep DIRENV_DIR | wc -l | sed 's/[0 ]//g'; };
      echoer () { export PROMPT="%f%F{yellow}$(direnv_yes)%f%F{red}$(make_superscript)%f%F{green}%n@%m %F{$016}%~%f %F{green}❯%f " };
      precmd_functions+=(echoer);
      CLICOLOR=1;
      PATH=/Users/mmai/scripts:$PATH;
      NIXPKGS_ALLOW_UNFREE=1;
      setopt rmstarsilent
    '';
  };
      #eval "$(/opt/homebrew/bin/brew shellenv)";

  # TODO fix the bashrc prompt
  
  programs.zellij = {
    enable = true;
    settings = {
      mouse_mode = true;
      theme = "gruvbox";
      pane_frames = true;
      ui.pane_frames.rounded_corners = false;
    };
  };

  programs.fzf = {
    enable = true;
  };

  programs.btop = {
    enable = true;
  };

  programs.htop = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "./.config/nvim" = {
      source = ./nvim;
      recursive = true;
    };  
    "./.config/helix" = {
      source = ./helix;
      recursive = true;
    };  
    "./.config/zellij" = {
      source = ./zellij;
      recursive = true;
    };  
    "./.config/wezterm" = {
      source = ./wezterm;
      recursive = true;
    };  
    "./.tmux.conf" = {
      source = ./tmux/dot_tmux.conf;
      recursive = false;
    };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mmai/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    DIRENV_WARN_TIMEOUT="600s";
    NIXPKGS_ALLOW_UNFREE=1;
    NIX_SHELL_PRESERVE_PROMPT=1;
  };

  # Let Home Manager install and manage itself.


}
