# ~/.zshrc · 交互式 zsh 的配置
# 从上往下依次设置命令路径、历史、补全、插件和提示符，最后定义自用命令。

# ── 01 命令路径与 Docker 补全 ──────────────────────
# 把 ~/.local/bin 放在 PATH 前面，优先查找这里安装的命令。
# Added by SkillHub CLI installer
export PATH="/Users/chenxinyi/.local/bin:$PATH"
# fpath 是 zsh 查找可自动加载函数的路径列表。这里把 Docker 的补全目录加到最前面。
# autoload 登记 compinit，下面一行在 Docker 补全尚未登记时调用它。
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/chenxinyi/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions

# ==================================================
# BEGIN MY ZSH SETUP
# ==================================================

# ── 02 命令历史 ───────────────────────────────────
# HISTFILE 指定历史文件。HISTSIZE 控制内存中的条数，SAVEHIST 控制磁盘保留的条数。
# ----- History -----

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# APPEND_HISTORY 追加历史，SHARE_HISTORY 在多个 zsh 会话之间共享历史。
# HIST_IGNORE_DUPS 跳过连续重复的命令，HIST_FIND_NO_DUPS 搜索历史时跳过已显示的重复条目。
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS


# ── 03 通用 Tab 补全 ──────────────────────────────
# 初始化 zsh 的补全系统。上方 Docker 区块也可能提前调用 compinit。
# ----- Completion -----

autoload -Uz compinit
compinit


# ── 04 目录跳转、模糊搜索与输入建议 ────────────────
# zoxide 根据访问过的目录提供跳转，例如用 z 加上目录名的一部分。
# ----- zoxide: smarter cd -----

eval "$(zoxide init zsh)"


# 加载 fzf 的 zsh 集成，为命令历史、文件和目录提供交互式模糊搜索。
# ----- fzf: fuzzy search -----

source <(fzf --zsh)


# 从 Homebrew 安装目录加载插件，用灰色文字显示可接在当前输入之后的历史命令。
# ----- Autosuggestions -----

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"


# ── 05 两行提示符 ─────────────────────────────────
# 提示符负责显示路径、状态和时间。语法高亮的加载行在本段函数之后。
# ----- Syntax highlighting -----
# Keep this near the end of .zshrc
# ---------- Prompt ----------

# 加载颜色、版本控制信息和钩子工具，再初始化颜色支持。
autoload -Uz colors vcs_info add-zsh-hook
colors

# Allow variables such as vcs_info to expand inside the prompt
setopt PROMPT_SUBST

# Git branch information
zstyle ':vcs_info:git:*' formats '%F{242}git:%F{magenta}%b%f'
zstyle ':vcs_info:*' enable git

# precmd 在每次显示提示符前运行。先刷新 Git 信息，后面的钩子再据此设置提示符。
add-zsh-hook precmd vcs_info

# Two-line minimal prompt
# 普通目录显示内存与时间，Git 仓库保留路径和分支，并显示时间。
# 第一行显示当前路径、Git 分支或内存占用以及时间，第二行留给输入。
# %~ 会把家目录缩写为 ~，%D 展开为指定格式的时间，%F 和 %f 控制文字颜色。
_ghostty_status_prompt() {
  if [[ -n $vcs_info_msg_0_ ]]; then
    PROMPT='%F{#89b4fa}%~%f${vcs_info_msg_0_:+  ${vcs_info_msg_0_}}  %F{#cba6f7}%D{%H:%M:%S}%f
%F{#a6e3a1}❯%f '
  else
    # 普通目录里用 fastfetch 读取内存占用。匹配到百分比才更新，读不到时显示 --。
    # 提示符中的 %% 会显示成一个百分号。
    local memory usage='--'
    local -a match
    memory=$(/opt/homebrew/bin/fastfetch --structure Memory --logo none --pipe true 2>/dev/null)
    if [[ $memory =~ '\(([0-9.]+)%\)' ]]; then
      usage="${match[1]}%%"
    fi
    PROMPT='%F{#89b4fa}%~%f  %F{#94e2d5}RAM '"$usage"'%f  %F{#cba6f7}%D{%H:%M:%S}%f
%F{#a6e3a1}❯%f '
  fi
}
add-zsh-hook precmd _ghostty_status_prompt

# ── 06 命令行语法高亮 ──────────────────────────────
# 加载 Homebrew 安装的高亮插件，给当前正在输入的命令着色。
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ── 07 常用目录快捷命令 ────────────────────────────
# 这些函数在当前 shell 里执行 cd，输入函数名就能切换目录。
# CD CS50P folder
cdCS50P(){
  cd /Users/chenxinyi/Documents/LAB/CS50P/Repositories
}

# CD CS50X folder
cdCS50X(){
  cd /Users/chenxinyi/Documents/LAB/CS50X/Repositories_C
}


# CD Documents folder
cdDoc(){
  cd /Users/chenxinyi/Documents
}

#CD LAB
cdLAB(){
cd /Users/chenxinyi/Documents/LAB
}

#CD Desktop
cdDes(){
cd /Users/chenxinyi/Desktop
}

#CD Ghostty config
cdGsconfig() {
    cd "$HOME/Library/Application Support/com.mitchellh.ghostty"
}

# ==================================================
# END MY ZSH SETUP
# ==================================================

# ── 08 GameHub 专用启动命令 ────────────────────────
# GameHub 已运行时先提示退出。随后在后台运行 Steam 443 启动脚本，输出写入日志。
openGamehub() {
  if pgrep -x GameHub >/dev/null; then
    print '请先正常退出 GameHub，再执行 openGamehub。'
    return 1
  fi
  nohup python3 "$HOME/.local/share/gamehub-steam-443/gamehub_steam_443.py" \
    >"$HOME/Library/Logs/gamehub-steam-443.log" 2>&1 </dev/null &!
}
# ── 09 CS50 编译快捷设置 ───────────────────────────
# 当前目录有 Makefile 时，按项目规则运行系统 make。
# 没有 Makefile 时，补上 clang、警告和调试选项，以及 CS50 头文件与链接库。
# command make 调用外部 make，避免再次调用这个同名函数。
# CS50 编译快捷配置
make() {
  if [[ -f GNUmakefile || -f makefile || -f Makefile ]]; then
    command make "$@"
  else
    command make CC=clang CFLAGS='-Wall -Wextra -g' \
      CPPFLAGS='-I/usr/local/include' \
      LDLIBS='/usr/local/lib/libcs50.a -lm' "$@"
  fi
}
