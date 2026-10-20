# 💻 Módulo 05 — Linux Desktop: Ferramentas Essenciais para Desenvolvedores

<div align="center">

![Vim](https://img.shields.io/badge/Vim-019733?style=for-the-badge&logo=vim&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![VS Code](https://img.shields.io/badge/VS%20Code-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![WSL](https://img.shields.io/badge/WSL-4EAA25?style=for-the-badge&logo=linux&logoColor=white)

</div>

## 🎯 Objetivos

- Configurar o Linux como estação de trabalho para desenvolvimento
- Dominar editores de texto no terminal (Vim, nano)
- Versionar projetos com Git e GitHub
- Trabalhar com containers no desktop (Docker Desktop)
- Integrar Windows e Linux com WSL2

---

## 📖 Resumo Conceitual

### Por que Linux para Desenvolvimento?

O Linux é o ambiente nativo da maioria dos servidores em produção. Desenvolver no mesmo ecossistema onde o software será implantado elimina surpresas de ambiente, diferenças de path, permissões e gerenciadores de pacotes. Além disso:

- Terminal poderoso (Bash, Zsh, Fish)
- Gerenciamento de pacotes nativo (apt, dnf, pacman)
- Docker roda nativamente (sem VM intermediária)
- Ferramentas de desenvolvimento são first-class citizens
- Performance superior em IO e rede

### WSL2 — O Melhor dos Dois Mundos

Windows Subsystem for Linux 2 (WSL2) roda um kernel Linux real dentro do Windows, com:

- Inicialização em segundos
- Integração com o sistema de arquivos do Windows (`/mnt/c/`)
- Suporte a Docker Desktop diretamente
- VS Code Remote Development integrado
- GPU passthrough para workloads de ML

---

## 💻 Comandos Essenciais

### Vim — O Editor Onipresente

```bash
# ─── Abrir e sair ─────────────────────────────────────────
vim arquivo.txt              # Abre o arquivo
:q                           # Sair (se não houver alterações)
:q!                          # Sair descartando alterações
:wq                          # Salvar e sair
:x                           # Salvar e sair (atalho)
:w                           # Salvar sem sair

# ─── Modos do Vim ─────────────────────────────────────────
# Modo NORMAL (padrão) — pressione ESC para voltar
# Modo INSERT — pressione i, a, o, A, I, O para entrar
# Modo VISUAL — pressione v, V, Ctrl+v para selecionar
# Modo COMMAND — pressione : para entrar

# ─── Navegação ────────────────────────────────────────────
h / j / k / l                ← / ↓ / ↑ / →
w / b                        Palavra seguinte / anterior
0 / $                        Início / fim da linha
gg / G                       Início / fim do arquivo
Ctrl+d / Ctrl+u              Meia página para baixo / cima

# ─── Edição básica ────────────────────────────────────────
dd                           Apaga linha (corta)
yy                           Copia linha (yank)
p / P                        Cola abaixo / acima
u                            Desfaz (undo)
Ctrl+r                       Refaz (redo)
/termo                       Busca por 'termo'
:%s/velho/novo/g             Substitui globalmente
```

### Git — Controle de Versão

```bash
# ─── Configuração inicial ──────────────────────────────────
git config --global user.name "Ever Ferreira"
git config --global user.email "ever@exemplo.com"
git config --global init.defaultBranch main
git config --global core.editor vim

# ─── Fluxo básico ──────────────────────────────────────────
git init                              # Inicia repositório
git add .                             # Adiciona tudo ao staging
git commit -m "mensagem"              # Commita
git status                            # Status do repositório
git log --oneline --graph             # Histórico compacto
git diff                              # Alterações não staged

# ─── Branches ──────────────────────────────────────────────
git branch                            # Lista branches
git checkout -b feat/nova-func        # Cria e muda para branch
git merge feat/nova-func              # Mescla ao branch atual
git branch -d feat/nova-func          # Deleta branch (local)

# ─── Remoto ────────────────────────────────────────────────
git remote add origin <url>           # Adiciona remoto
git push -u origin main               # Primeiro push
git pull                              # Puxa alterações
git clone <url>                       # Clona repositório
```

### EditorConfig e Boas Práticas

```ini
# .editorconfig — consistência entre editores
root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

---

## 🛠️ Ferramentas Essenciais

### Stack de Desenvolvimento Recomendada

| Ferramenta | Instalação | Para que serve |
|------------|-----------|----------------|
| **VS Code** | `sudo snap install code --classic` | IDE completa com WSL Remote |
| **Docker Desktop** | Download site oficial | Containers com WSL2 backend |
| **Postman** / Insomnia | `sudo snap install postman` | Teste de APIs |
| **htop** | `sudo apt install htop` | Monitor do sistema |
| **tmux** | `sudo apt install tmux` | Multiplexador de terminal |
| **tree** | `sudo apt install tree` | Visualizar árvore de diretórios |
| **httpie** | `sudo apt install httpie` | Cliente HTTP para terminal |
| **jq** | `sudo apt install jq` | Processar JSON no terminal |

### WSL2 — Setup Otimizado

```bash
# No PowerShell (Admin):
# wsl --install -d Ubuntu-24.04

# Dentro do WSL:
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential git curl wget unzip -y

# Integração com VS Code Remote
# Instale a extensão "Remote - WSL" no VS Code Windows
# Depois: code .   (dentro do WSL abre o VS Code conectado)

# Acessar arquivos do Windows
ls /mnt/c/Users/conta/

# Criar alias para navegação rápida no ~/.bashrc
echo "alias homew='cd /mnt/c/Users/conta/'" >> ~/.bashrc
```

---

## 🧪 Troubleshooting & Boas Práticas

<details>
<summary>🔍 <b>Problemas comuns</b></summary>

| Problema | Solução |
|----------|---------|
| Vim travou? | `ESC` para normal, depois `:q!` para sair. Se nada funcionar: `Ctrl+Z` suspende, depois `kill %1` |
| Git: `The file will have its original line endings` | `git config --global core.autocrlf input` (WSL) |
| Docker WSL: `cannot connect to Docker daemon` | Habilite WSL integration no Docker Desktop Settings > Resources > WSL |
| VS Code não abre do WSL | `code --install-extension ms-vscode-remote.remote-wsl` e tente novamente |
| `permission denied` no /mnt/c | Arquivos Windows mantêm permissões NTFS — use `sudo` se necessário |

</details>

<details>
<summary>💡 <b>Dicas de produtividade</b></summary>

- 🔥 **Aliases matadores** para o `~/.bashrc`:

```bash
alias gs='git status'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all --decorate'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias ..='cd ..'
alias ...='cd ../..'
```

- 🚀 **VS Code + WSL**: abra qualquer pasta do WSL com `code .` diretamente do terminal
- 📝 **Vim**: pratique 10 minutos por dia no [vim-adventures.com](https://vim-adventures.com) ou `vimtutor`
- 🐳 **Docker Desktop + WSL2**: use `docker ps` sem Docker Desktop — o engine roda nativo no WSL

</details>

---

## 🔗 Navegação

| ← Anterior | Principal |
|:----------:|:---------:|
| [Módulo 04: Serviços Linux & IaC](../04-servicos-linux/README.md) | [Voltar ao README](../README.md) |

---

<div align="center">

*"O terminal não é uma limitação — é a ferramenta mais poderosa que um desenvolvedor pode dominar."*

</div>