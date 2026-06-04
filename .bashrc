# ~/.bashrc — Daniel's dotfiles

# ── Base ──────────────────────────────────────────────────────────────────────
export EDITOR=nano
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# Better history
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# ── Prompt ────────────────────────────────────────────────────────────────────
# Clean prompt: user@dir (git branch)
parse_git_branch() {
  git branch 2>/dev/null | grep '*' | sed 's/* //'
}
export PS1='\[\e[0;32m\]\u\[\e[0m\]:\[\e[0;34m\]\W\[\e[0;33m\]$(b=$(parse_git_branch); [ -n "$b" ] && echo " ($b)")\[\e[0m\] $ '

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah --color=auto'
alias la='ls -A'
alias l='ls -CF'

# ── Git ───────────────────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -10'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# ── Claude Code ───────────────────────────────────────────────────────────────
alias cc='claude'
alias ccc='claude --continue'                    # retomar última sesión
alias ccp='claude --print'                       # output sin interactividad
alias ccm='claude /compact'                      # compactar contexto
alias new-task='claude /clear && claude'         # limpiar y empezar tarea nueva

# Abrir proyecto con contexto de CLAUDE.md local
dev() {
  local dir="${1:-.}"
  cd "$dir" && claude
}

# ── Docker ────────────────────────────────────────────────────────────────────
alias dk='docker'
alias dkc='docker compose'
alias dkcu='docker compose up -d'
alias dkcd='docker compose down'
alias dkl='docker logs -f'
alias dkps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

# ── Utilidades ────────────────────────────────────────────────────────────────
alias h='history | grep'           # h <término> — buscar en historial
alias ports='ss -tulpn'            # ver puertos en uso
alias myip='curl -s ifconfig.me'
alias reload='source ~/.bashrc'

# Crear directorio y entrar
mkcd() { mkdir -p "$1" && cd "$1"; }

# ── Node / npm ────────────────────────────────────────────────────────────────
alias ni='npm install'
alias nid='npm install --save-dev'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'

# ── Python ────────────────────────────────────────────────────────────────────
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv && source .venv/bin/activate'
alias activate='source .venv/bin/activate'

# ── WSL helpers ───────────────────────────────────────────────────────────────
alias winuser='cd /mnt/c/Users/Daniel'          # acceso rápido a Windows si hace falta
alias explorer='explorer.exe .'                  # abrir carpeta en Explorer

# Abrir Cursor desde WSL en el directorio actual
cursor() {
  /mnt/c/Users/Daniel/AppData/Local/Programs/cursor/Cursor.exe "${@:-.}" &
}

# ── Secrets (MCP tokens, etc.) ────────────────────────────────────────────────
[ -f "$HOME/.env.secrets" ] && source "$HOME/.env.secrets"

# NVM (auto-added by dev-setup)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
