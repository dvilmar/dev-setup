# dotfiles

Configuración portable para WSL2 + Cursor + Claude Code.

## Instalación en máquina nueva

```bash
git clone https://github.com/TU_USUARIO/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
source ~/.bashrc
```

Un comando. Todo listo.

## Estructura

```
dotfiles/
├── .bashrc              # Shell: aliases, prompt, utilidades
├── .gitconfig           # Git global
├── .gitignore_global    # Gitignore global
├── .wslconfig           # Recursos WSL2 (se copia a /mnt/c/Users/Daniel/)
├── claude/
│   └── CLAUDE.md        # Memoria global de Claude Code (~/.claude/CLAUDE.md)
├── scripts/             # Scripts de utilidad (añadir según necesidad)
└── install.sh           # Setup automático
```

## Aliases principales

| Alias | Comando | Para qué |
|-------|---------|----------|
| `cc` | `claude` | Abrir Claude Code |
| `ccc` | `claude --continue` | Retomar última sesión |
| `ccm` | `claude /compact` | Compactar contexto |
| `new-task` | `/clear && claude` | Limpiar y nueva tarea |
| `dev [dir]` | `cd + claude` | Entrar a proyecto con Claude |
| `dkcu` | `docker compose up -d` | Levantar Docker |
| `gs` | `git status` | Estado git |
| `gl` | `git log --oneline` | Log compacto |

## Actualizar desde GitHub

```bash
cd ~/dotfiles && git pull && bash install.sh
```

## Primer uso tras clonar

1. Edita `.gitconfig` → pon tu email real
2. Edita `claude/CLAUDE.md` → describe tu proyecto actual
3. Sube a GitHub como repo privado
