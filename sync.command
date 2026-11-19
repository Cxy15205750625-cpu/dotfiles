#!/bin/zsh -f

set -e

if (( $# > 1 )) || { (( $# == 1 )) && [[ $1 != --dry-run ]]; }; then
  printf '用法：%s [--dry-run]\n' "${0:t}" >&2
  exit 2
fi

repo=${0:A:h}
if [[ $(git -C "$repo" rev-parse --show-toplevel) != "$repo" ]]; then
  print -u2 '请把此脚本放在 dotfiles 仓库根目录。'
  exit 1
fi
git_dir=$(git -C "$repo" rev-parse --absolute-git-dir)

ghostty_dir='Library/Application Support/com.mitchellh.ghostty'
files=(
  .zshrc
  .emacs
  .gitconfig
  .gitignore_global
  .config/btop/btop.conf
  .config/fish/config.fish
  .config/karabiner/karabiner.json
  'Library/Application Support/Thor/apps.json'
  projects/LAB/.vscode/settings.json
  squirrel.custom.yaml
  "$ghostty_dir/config.ghostty"
  "$ghostty_dir/shaders/cursor_warp.glsl"
  "$ghostty_dir/shaders/cursor_warp.LICENSE"
)

backup_dir=''
failed=0
changes=0
for relative in "${files[@]}"; do
  case $relative in
    projects/LAB/*) source="$HOME/Documents/${relative#projects/}" ;;
    squirrel.custom.yaml) source="$HOME/Library/Rime/$relative" ;;
    *) source="$HOME/$relative" ;;
  esac
  destination="$repo/$relative"

  if [[ ! -f $source || ! -r $source ]]; then
    printf '跳过，无法读取：%s\n' "$source" >&2
    failed=1
    continue
  fi
  if [[ ${destination:h:A} != ${destination:h} || -L $destination || ( -e $destination && ! -f $destination ) ]]; then
    printf '跳过，目标路径异常：%s\n' "$destination" >&2
    failed=1
    continue
  fi
  if cmp -s "$source" "$destination"; then
    continue
  fi

  changes=$((changes + 1))
  if [[ $1 == --dry-run ]]; then
    printf '待同步  %s\n' "$relative"
    continue
  fi

  if [[ -f $destination ]]; then
    if [[ -z $backup_dir ]]; then
      backup_dir=$(mktemp -d "$git_dir/dotfiles-sync.XXXXXXXX")
      printf '旧副本备份  %s\n' "$backup_dir"
    fi
    backup="$backup_dir/$relative"
    mkdir -p "$backup:h"
    cp -p "$destination" "$backup"
  fi

  mkdir -p "$destination:h"
  temp=$(mktemp "$destination:h/.dotfiles-sync.XXXXXXXX")
  if ! cp -p "$source" "$temp" || ! mv -f "$temp" "$destination"; then
    rm -f "$temp"
    printf '复制失败：%s\n' "$relative" >&2
    failed=1
    continue
  fi
  printf '已同步  %s\n' "$relative"
done

if (( changes == 0 && failed == 0 )); then
  print '配置文件已经一致。'
fi

if [[ $1 != --dry-run ]]; then
  git -C "$repo" status --short --untracked-files=all -- "${files[@]}" "${0:t}"
fi
exit "$failed"
