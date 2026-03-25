{ config, pkgs, lib, hostname ? "unknown", ... }:

let
  fromGitHub = rev: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = rev;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      rev = rev;
    };
  };
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  tmuxColors = {
    Mac      = { bg = "colour204"; fg = "colour0"; };
    bee      = { bg = "colour240"; fg = "colour249"; };
    logicLHR = { bg = "colour9";   fg = "colour255"; };
    rpi4     = { bg = "colour40";  fg = "colour0"; };
  }.${hostname} or { bg = "colour255"; fg = "colour0"; };
in {
  # are we on Linux?
  targets.genericLinux.enable = isLinux;
  targets.genericLinux.nixGL.defaultWrapper = "none";
  # can the gpu on bee mini pc
  targets.genericLinux.gpu.enable = isLinux && hostname != "bee";
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tbrowne";
  home.homeDirectory = if isDarwin then "/Users/tbrowne" else "/home/tbrowne";

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
    bqn386
    chafa # sixel viewer
    fuse
    nodejs
    asciinema
    nnn
    yazi
    nerd-fonts.iosevka
    nerd-fonts.comic-shanns-mono
    nerd-fonts.lekton
    nerd-fonts.victor-mono
    nerd-fonts._3270
    nerd-fonts.blex-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.mononoki
    nerd-fonts.daddy-time-mono
    nerd-fonts.envy-code-r
    nerd-fonts.fantasque-sans-mono
    tree-sitter
    ripgrep
    claude-code

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];           

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    historyLimit = 20000;
    mouse = true;
    keyMode = "emacs";
    extraConfig = ''
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R
      set -g status-bg ${tmuxColors.bg}
      set -g status-fg ${tmuxColors.fg}
      set -ag terminal-overrides ",*256col*:Tc"
      set -g status-interval 3
      set -g status-right "#(~/scripts/tmux-status)"
      set -g status-right-length 120
    '';
  };

  programs.zsh = if isDarwin then {
    enable = true;
    autocd = true;
    enableCompletion = true;
    shellAliases = {
      ls = "ls -alG";
      vim = "nvim";
      sd="cd ~ && cd \$(find * -type d | fzf)";
    };
    initContent = ''
      make_superscript () { sed 'y/0123456789/⁰¹²³⁴⁵⁶⁷⁸⁹/' <<< $SHLVL; };
      direnv_yes () { env | grep DIRENV_DIR | wc -l | sed 's/[0 ]//g'; };
      nixshell_yes () { env | grep IN_NIX_SHELL | wc -l | sed 's/[0 ]//g'; };
      echoer () { export PROMPT="%f%F{yellow}$(nixshell_yes)%f%F{red}$(make_superscript)%f%F{green}%n@%m %F{$016}%~%f %F{green}❯%f " };
      precmd_functions+=(echoer);
      CLICOLOR=1;
      PATH=${config.home.homeDirectory}/scripts:$PATH;
      NIXPKGS_ALLOW_UNFREE=1;
      setopt rmstarsilent

      # Export secrets as environment variables
      export OPENROUTER_API_KEY="$(cat ${config.sops.secrets.openrouter_api_key.path} 2>/dev/null || true)"
      export WHATSAPP_TOKEN="$(cat ${config.sops.secrets.whatsapp_token.path} 2>/dev/null || true)"
      export XAI_API_KEY="$(cat ${config.sops.secrets.xai_api_key.path} 2>/dev/null || true)"
      export MASSIVE_API_KEY="$(cat ${config.sops.secrets.massive_api_key.path} 2>/dev/null || true)"
      export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets.anthropic_api_key.path} 2>/dev/null || true)"
      export MASSIVE_AWS_ACCESS_KEY_ID="$(cat ${config.sops.secrets.massive_aws_access_key_id.path} 2>/dev/null || true)"
      export MASSIVE_AWS_SECRET_ACCESS_KEY="$(cat ${config.sops.secrets.massive_aws_secret_access_key.path} 2>/dev/null || true)"

    '';
  } else {
    enable = false;
  };
    
  
  programs.fzf = {
    enable = true;
  };

  # github cli 
  programs.gh = {
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
    enableBashIntegration = isLinux;
  };

  programs.wezterm = {
    enable = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.jujutsu = {
    enable = true;
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # sops configuration
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;

    secrets = {
      openrouter_api_key = {};
      whatsapp_token = {};
      xai_api_key = {};
      massive_api_key = {};
      anthropic_api_key = {};
      massive_aws_access_key_id = {};
      massive_aws_secret_access_key = {};
    };
  };

  # Set environment variables from secrets
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  # Export secrets as environment variables in shell init
  programs.bash.initExtra = ''
    export OPENROUTER_API_KEY="$(cat ${config.sops.secrets.openrouter_api_key.path} 2>/dev/null || true)"
    export WHATSAPP_TOKEN="$(cat ${config.sops.secrets.whatsapp_token.path} 2>/dev/null || true)"
    export XAI_API_KEY="$(cat ${config.sops.secrets.xai_api_key.path} 2>/dev/null || true)"
    export MASSIVE_API_KEY="$(cat ${config.sops.secrets.massive_api_key.path} 2>/dev/null || true)"
    export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets.anthropic_api_key.path} 2>/dev/null || true)"
    export MASSIVE_AWS_ACCESS_KEY_ID="$(cat ${config.sops.secrets.massive_aws_access_key_id.path} 2>/dev/null || true)"
    export MASSIVE_AWS_SECRET_ACCESS_KEY="$(cat ${config.sops.secrets.massive_aws_secret_access_key.path} 2>/dev/null || true)"
  '';


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "./.config/nvim" = {
      source = ./nvim;
      recursive = true;
    };  
    "./.config/wezterm" = {
      source = ./wezterm;
      recursive = true;
    };  
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    "./.config/claude" = {
      source = ./claude;
      recursive = true;
    };
    "./scripts/tmux-status" = {
      source = if isDarwin then ./scripts/tmux-status-darwin else ./scripts/tmux-status;
      executable = true;
    };
  };


  home.shellAliases = { 
    vim = "nvim"; 
    n = "nnn -S -Q";
    y = "yazi";
  };
}
