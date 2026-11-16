# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="blinks"

# History.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change the frequency the auto-updater is run (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to set how old an update must be before it's applied, manually or via the auto-updater (in days).
# zstyle ':omz:update' cooldown 10

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# load plugins.
# fpath 是 zsh 查找可自动加载函数的路径列表。这里把 Docker 的补全目录加到最前面。
# autoload 登记 compinit，下面一行在 Docker 补全尚未登记时调用它。
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
plugins=(git zoxide fzf zsh-autosuggestions zsh-syntax-highlighting)
fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit

source $ZSH/oh-my-zsh.sh

# User configuration

## APPEND_HISTORY 追加历史，SHARE_HISTORY 在多个 zsh 会话之间共享历史。
## HIST_IGNORE_DUPS 跳过连续重复的命令，HIST_FIND_NO_DUPS 搜索历史时跳过已显示的重复条目。
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

## 从 Homebrew 安装目录加载插件，用灰色文字显示可接在当前输入之后的历史命令。
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

## Git branch information
zstyle ':vcs_info:git:*' formats '%F{242}git:%F{magenta}%b%f'
zstyle ':vcs_info:*' enable git

## precmd 在每次显示提示符前运行。先刷新 Git 信息，后面的钩子再据此设置提示符。
add-zsh-hook precmd vcs_info

## 常用目录 shortcuts.

### CD CS50P folder
cdCS50P(){
  cd /Users/chenxinyi/Documents/LAB/CS50P/Repositories
}

### CD CS50X folder
cdCS50X(){
  cd /Users/chenxinyi/Documents/LAB/CS50X/Repositories_C
}

### CD Documents folder
cdDoc(){
  cd /Users/chenxinyi/Documents
}

### CD LAB
cdLAB(){
cd /Users/chenxinyi/Documents/LAB
}

###CD Desktop
cdDes(){
cd /Users/chenxinyi/Desktop
}

###CD Ghostty config
cdGsconfig() {
    cd "$HOME/Library/Application Support/com.mitchellh.ghostty"
}

## gamehub 启动命令
openGamehub() {
  if pgrep -x GameHub >/dev/null; then
    print '请先正常退出 GameHub，再执行 openGamehub。'
    return 1
  fi
  nohup python3 "$HOME/.local/share/gamehub-steam-443/gamehub_steam_443.py" \
    >"$HOME/Library/Logs/gamehub-steam-443.log" 2>&1 </dev/null &!
}

## Sync config
sync_zshrc(){
  local repo="$HOME/Documents/dotfiles"

  cp "$HOME/.zshrc" "$repo/.zshrc" &&
    git -C "$repo" status --short -- .zshrc
}

# makefile


# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
