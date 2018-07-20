# Setup fzf
# ---------
export FZF_DEFAULT_OPTS='--exact' # prefer exact matches

# Set install dir
if [[ $OSTYPE == 'linux-gnu' ]]; then
  export FZF_PREFIX=/opt
elif [[ $OSTYPE == darwin* ]]; then
  export FZF_PREFIX=/usr/local/opt
else
  # FZF not available
  return 0
fi

if command -v ag > /dev/null; then
  export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || ag --hidden --ignore .git -g "") 2> /dev/null'
else
  export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
  echo "[FZF Module]: 'ag' not found, falling back to 'find' (no hidden files)"
fi

# Auto-completion
[[ $- == *i* ]] && source "$FZF_PREFIX/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
source "$FZF_PREFIX/fzf/shell/key-bindings.zsh"

# better zz from fasd
function zz() {
  local dir
  dir="$(fasd -Rdl "$1" | fzf --query="$1" -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

# does global file search, shows selected file in bat
function show() {
    local file
    file=$(locate / | fzf --query="$*" --select-1 --exit-0)
    [ -n "$file" ] && bat "$file"
}

# does local file search, from current directory, displays file in bat
function showl() {
    local file
    file=$(fzf --query="$*"\
      --select-1 --exit-0)
    [ -n "$file" ] && bat "$file"
    fi
}

# global file search -> vim
function vf() {
  local file;
  file="$(locate / | fzf --query="$*" --select-1 --exit-0)";  
  [ -n "$file" ] && vim "$file";
}

# Pick file to edit
function vfl() {
  local file
  file=$(fzf --exact --height 40% --reverse --query="$*"  --select-1 --exit-0)
  [ -n "$file" ] && vim "$file"
}


# Navigation functions from https://github.com/nikitavoloboev/dotfiles/blob/master/zsh/functions/fzf-functions.zsh#L1
# fa <dir> - Search dirs and cd to them
# TODO: Use sharkdp/fd instead, to leverage gitignore?
fa() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fah <dir> - Search dirs and cd to them (included hidden dirs)
fah() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# cd into the directory of the selected file
fl() {
  local file
  local dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
  ls
}


# Search env variables
fenv() {
  local out
  out=$(env | fzf)
  # echo $(echo $out | cut -d= -f2)
  echo $(echo $out)
}


cd..(){
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR"
}
