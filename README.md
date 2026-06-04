# dev-setup

Entorno portable para WSL2 + Cursor + Claude Code. Un comando lo levanta todo en una máquina nueva.

## Instalación en máquina nueva

```bash
git clone git@github.com:dvilmar/dev-setup.git ~/dev-setup
cd ~/dev-setup
bash bootstrap.sh
source ~/.bashrc
```

`bootstrap.sh` es interactivo — confirmas paso a paso qué instalar.

## Post-instalación: tokens MCP

```bash
cp .env.example ~/.env.secrets
nano ~/.env.secrets   # rellena VERCEL_TOKEN, SUPABASE_URL, SUPABASE_SERVICE_KEY
source ~/.bashrc      # recarga secrets
```

Después reinicia Claude Code para que los MCP servers arranquen.

## Estructura

```
dev-setup/
├── bootstrap.sh                    # Setup completo interactivo
├── .env.example                    # Plantilla de tokens (nunca commitear .env.secrets)
├── .bashrc                         # Shell: aliases, prompt, NVM, secrets loader
├── .gitconfig                      # Git global
├── .gitignore_global               # Gitignore global
├── .wslconfig                      # Recursos WSL2 (16GB RAM, 6 cores, mirrored)
├── config/
│   ├── claude/
│   │   ├── CLAUDE.md               # Memoria global de Claude Code
│   │   ├── mcps.json               # Configuración de MCP servers
│   │   └── settings.json           # Tema, plugins, permisos, hooks
│   └── cursor/
│       ├── settings.json           # Settings de Cursor (se aplica en Windows)
│       ├── extensions.txt          # Extensiones a instalar
│       └── skills/                 # 14 skills de Cursor Agent
└── install/
    ├── system.sh                   # Paquetes base (git, curl, jq, fzf, ripgrep…)
    ├── python.sh                   # Python 3 + pipx
    ├── node.sh                     # Node.js via NVM
    ├── claude.sh                   # Claude Code CLI
    ├── claude-plugins.sh           # Plugin Vercel + settings de Claude
    ├── mcps.sh                     # MCP servers → ~/.claude/settings.json
    ├── skills.sh                   # Skills → ~/.cursor/skills-cursor/
    ├── cursor.sh                   # Extensiones de Cursor
    ├── cursor-settings.sh          # Settings → AppData/Roaming/Cursor/User/
    ├── dotfiles.sh                 # Symlinks de dotfiles en HOME
    └── docker.sh                   # Info de Docker setup
```

## MCP servers incluidos

| MCP | Para qué | Requiere |
|-----|----------|----------|
| `filesystem` | Leer/escribir archivos en `/home/danielvilar` | — |
| `docker` | Gestionar contenedores y compose | Docker corriendo |
| `vercel` | Deployments, env vars, logs | `VERCEL_TOKEN` |
| `google-drive` | Leer archivos de Drive | `gdrive-credentials.json` |
| `supabase` | Consultas a BD (read-only) | `SUPABASE_URL` + `SUPABASE_SERVICE_KEY` |

## Skills de Cursor incluidos

`babysit` · `canvas` · `create-hook` · `create-rule` · `create-skill` · `create-subagent` · `loop` · `migrate-to-skills` · `sdk` · `shell` · `split-to-prs` · `statusline` · `update-cli-config` · `update-cursor-settings`

## Aliases principales

| Alias | Para qué |
|-------|----------|
| `cc` | Abrir Claude Code |
| `ccc` | Retomar última sesión |
| `ccm` | Compactar contexto (`/compact`) |
| `new-task` | Limpiar y nueva tarea |
| `dev [dir]` | Entrar a proyecto con Claude |
| `gs` / `gl` / `gd` | git status / log / diff |
| `dkcu` / `dkcd` | Docker compose up / down |
| `nrd` / `nrb` | npm run dev / build |
| `ports` | Puertos en uso (`ss -tulpn`) |
| `reload` | Recargar `.bashrc` |

## Actualizar desde GitHub

```bash
cd ~/dev-setup && git pull && bash bootstrap.sh
```

Solo ejecuta los pasos que confirmes — es seguro re-ejecutar.
