#!/usr/bin/env bash
# =============================================================================
#  user-management.sh — Provisionamento de Usuários e Grupos no Linux
# =============================================================================
#  Descrição:
#    Script de Infraestrutura como Código (IaC) para criação automatizada
#    de grupos, usuários, diretórios e permissões em servidores Linux.
#
#  Baseado no módulo "Trabalhando com Usuários, Arquivos e Diretórios no Linux"
#  da formação Linux Fundamentals (DIO).
#
#  Uso:
#    sudo ./user-management.sh
#
#  Requisitos:
#    - Execução com privilégios root (sudo)
#    - Sistema baseado em Red Hat (useradd, groupadd) ou Debian
#
#  Autor: Ever Ferreira
#  Repositório: https://github.com/everferreira/Formacao_Linux_Fundamentals
# =============================================================================

set -euo pipefail  # Sai em erro, trata variáveis não definidas, falha em pipes

# ─── Cores para output ───────────────────────────────────────────────────────
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# ─── Funções auxiliares ──────────────────────────────────────────────────────
log_info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# ─── Verificação de root ─────────────────────────────────────────────────────
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Este script deve ser executado como root (use sudo)."
        exit 1
    fi
}

# ─── Definição de grupos ─────────────────────────────────────────────────────
setup_groups() {
    local groups=("desenvolvedores" "administradores")

    for group in "${groups[@]}"; do
        if getent group "$group" > /dev/null 2>&1; then
            log_warn "Grupo '$group' já existe. Pulando..."
        else
            groupadd "$group"
            log_success "Grupo '$group' criado com sucesso."
        fi
    done
}

# ─── Definição de usuários ───────────────────────────────────────────────────
# Formato: nome:grupo_primario:shell:senha
setup_users() {
    local users=(
        "maria:desenvolvedores:/bin/bash:senha123"
        "joao:desenvolvedores:/bin/bash:senha456"
        "admin:administradores:/bin/bash:senha789"
    )

    for entry in "${users[@]}"; do
        IFS=':' read -r username primary_group shell password <<< "$entry"

        if id "$username" > /dev/null 2>&1; then
            log_warn "Usuário '$username' já existe. Pulando..."
            continue
        fi

        # Cria o usuário com diretório home, shell definido e grupo primário
        useradd -m -s "$shell" -G "$primary_group" "$username"
        echo "$password" | passwd --stdin "$username" > /dev/null 2>&1

        log_success "Usuário '$username' criado (grupo: $primary_group)."
    done
}

# ─── Criação de diretórios pessoais ──────────────────────────────────────────
setup_directories() {
    local dirs=(
        "/home/maria/arquivos:maria:desenvolvedores:770"
        "/home/joao/projetos:joao:desenvolvedores:770"
        "/home/admin/documentos:admin:administradores:770"
    )

    for entry in "${dirs[@]}"; do
        IFS=':' read -r dir_path owner group perm <<< "$entry"

        if [[ -d "$dir_path" ]]; then
            log_warn "Diretório '$dir_path' já existe. Pulando..."
            continue
        fi

        mkdir -p "$dir_path"
        chown "$owner":"$group" "$dir_path"
        chmod "$perm" "$dir_path"

        log_success "Diretório '$dir_path' criado (owner: $owner:$group, perms: $perm)."
    done
}

# ─── Main ────────────────────────────────────────────────────────────────────
main() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  Provisionamento de Usuários e Grupos${NC}"
    echo -e "${BLUE}  Linux Fundamentals — Módulo 02${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""

    check_root

    log_info "Configurando grupos..."
    setup_groups
    echo ""

    log_info "Criando usuários..."
    setup_users
    echo ""

    log_info "Configurando diretórios e permissões..."
    setup_directories
    echo ""

    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  Provisionamento concluído com sucesso!${NC}"
    echo -e "${GREEN}============================================${NC}"
}

main "$@"