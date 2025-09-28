# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

pathmunge() {
  [ -h "$1" ] && return

  case ":${PATH}:" in
  *:"$1":*) ;;
  *)
    if [ "$2" = "after" ]; then
      PATH=$PATH:$1
    else
      PATH=$1:$PATH
    fi
    ;;
  esac
}

pathmunge /var/lib/flatpak/exports/bin

export BUN_INSTALL="$HOME/.bun"
pathmunge "$BUN_INSTALL/bin"

export NPM_CONFIG_PREFIX="$HOME/.npm-global"
pathmunge "$NPM_CONFIG_PREFIX/bin"

export GOPATH="$HOME/.go"
pathmunge "$GOPATH/bin"

unset -f pathmunge

[ -f /etc/os-release ] && . /etc/os-release

. "$HOME/.cargo/env"

[[ $- == *i* ]] || return 0
[ ! -t 0 ] && return 0

if [[ "$(tty)" =~ ^/dev/tty[1-6]$ ]]; then
  export LC_ALL="en_US.UTF-8"
  export LANGUAGE="en_US.UTF-8"
  export LANG="en_US.UTF-8"
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

command -v mcfly >/dev/null 2>&1 && eval "$(mcfly init bash)"

command -v vfox >/dev/null 2>&1 && eval "$(vfox activate bash)"

export PS1='\e[7;36m\] ${NAME} \[\e[34m\] \u@\h:\w \[\e[0m\]\n\$ '
