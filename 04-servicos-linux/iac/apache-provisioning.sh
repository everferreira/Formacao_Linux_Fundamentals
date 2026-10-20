#!/usr/bin/env bash
# =============================================================================
#  apache-provisioning.sh — Provisionamento Automatizado de Servidor Web
# =============================================================================
#  Descrição:
#    Script de Infraestrutura como Código (IaC) para instalação e configuração
#    automatizada do Apache HTTP Server com uma aplicação web de demonstração.
#
#  Baseado no módulo "Serviços Linux e Infraestrutura como Código" da formação
#  Linux Fundamentals (DIO), referenciando o repositório do instrutor
#  Denilson Bonatti: https://github.com/denilsonbonatti/linux-site-dio
#
#  Uso:
#    sudo ./apache-provisioning.sh
#
#  Requisitos:
#    - Execução com privilégios root (sudo)
#    - Sistema baseado em Debian/Ubuntu (apt-get)
#    - Conexão com a internet para download de pacotes e assets
#
#  Autor: Ever Ferreira
#  Repositório: https://github.com/everferreira/Formacao_Linux_Fundamentals
# =============================================================================

set -euo pipefail

# ─── Constantes ──────────────────────────────────────────────────────────────
readonly APP_REPO="https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip"
readonly APP_DIR="/tmp/linux-site-dio-main"
readonly WEB_ROOT="/var/www/html"
readonly BACKUP_DIR="/var/www/backup-$(date +%Y%m%d-%H%M%S)"

# ─── Flags e variáveis de controle ───────────────────────────────────────────
FORCE=false
DRY_RUN=false

# ─── Cores para output ───────────────────────────────────────────────────────
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# ─── Funções auxiliares ──────────────────────────────────────────────────────
log_info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_step()    { echo -e "${CYAN}─── $* ───${NC}"; }

# ─── Help ────────────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
Uso: $(basename "$0") [opções]

Opções:
  -f, --force    Força reinstalação mesmo que o Apache já esteja instalado
  -n, --dry-run  Simula a execução sem modificar o sistema
  -h, --help     Exibe esta mensagem de ajuda

Exemplo:
  sudo ./apache-provisioning.sh --force
EOF
    exit 0
}

# ─── Parse de argumentos ─────────────────────────────────────────────────────
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--force)  FORCE=true; shift ;;
            -n|--dry-run) DRY_RUN=true; shift ;;
            -h|--help)   usage ;;
            *) log_error "Argumento desconhecido: $1"; usage ;;
        esac
    done
}

# ─── Verificação de root ─────────────────────────────────────────────────────
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Este script deve ser executado como root (use sudo)."
        exit 1
    fi
}

# ─── Atualização do sistema ──────────────────────────────────────────────────
system_update() {
    log_step "Atualizando lista de pacotes"
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] apt-get update"
        return
    fi
    apt-get update -qq || {
        log_error "Falha ao atualizar a lista de pacotes."
        exit 1
    }
    log_success "Lista de pacotes atualizada."
}

# ─── Instalação de pacotes ───────────────────────────────────────────────────
install_packages() {
    local packages=("apache2" "unzip" "wget")
    local to_install=()

    log_step "Verificando pacotes necessários"

    for pkg in "${packages[@]}"; do
        if dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
            if [[ "$FORCE" == true ]]; then
                to_install+=("$pkg")
                log_info "$pkg já instalado. Modo --force: reinstalando..."
            else
                log_success "$pkg já instalado. Pulando."
            fi
        else
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        log_info "Nenhum pacote novo para instalar."
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] apt-get install -y ${to_install[*]}"
        return
    fi

    apt-get install -y "${to_install[@]}" || {
        log_error "Falha ao instalar pacotes: ${to_install[*]}"
        exit 1
    }
    log_success "Pacotes instalados: ${to_install[*]}"
}

# ─── Backup do conteúdo web existente ────────────────────────────────────────
backup_existing() {
    if [[ -d "$WEB_ROOT" ]] && [[ -n "$(ls -A "$WEB_ROOT" 2>/dev/null)" ]]; then
        log_step "Fazendo backup do conteúdo atual em $BACKUP_DIR"
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY-RUN] mkdir -p $BACKUP_DIR && cp -r $WEB_ROOT/* $BACKUP_DIR/"
            return
        fi
        mkdir -p "$BACKUP_DIR"
        cp -r "$WEB_ROOT"/* "$BACKUP_DIR/" 2>/dev/null || true
        log_success "Backup realizado em $BACKUP_DIR"
    fi
}

# ─── Download e deploy da aplicação ──────────────────────────────────────────
deploy_application() {
    log_step "Baixando e implantando a aplicação"
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] wget $APP_REPO -O /tmp/main.zip"
        log_info "[DRY-RUN] unzip + cp para $WEB_ROOT"
        return
    fi

    local tmp_zip="/tmp/main.zip"
    cd /tmp

    # Download
    wget -q --show-progress "$APP_REPO" -O "$tmp_zip" || {
        log_error "Falha no download da aplicação de $APP_REPO"
        exit 1
    }
    log_success "Download concluído."

    # Extração
    unzip -q -o "$tmp_zip" -d /tmp/ || {
        log_error "Falha ao extrair o arquivo ZIP."
        exit 1
    }
    log_success "Arquivos extraídos em /tmp/."

    # Cópia para o webroot
    if [[ ! -d "$APP_DIR" ]]; then
        log_error "Diretório da aplicação não encontrado: $APP_DIR"
        exit 1
    fi

    cp -R "$APP_DIR"/* "$WEB_ROOT/" || {
        log_error "Falha ao copiar arquivos para $WEB_ROOT"
        exit 1
    }
    log_success "Aplicação copiada para $WEB_ROOT"

    # Limpeza
    rm -f "$tmp_zip"
    rm -rf "$APP_DIR"
    log_info "Arquivos temporários removidos."
}

# ─── Verificação pós-instalação ──────────────────────────────────────────────
verify_installation() {
    log_step "Verificando instalação"

    # Verifica se o Apache está rodando
    if systemctl is-active --quiet apache2; then
        log_success "Apache está rodando."
    else
        log_warn "Apache não está ativo. Tentando iniciar..."
        if [[ "$DRY_RUN" == false ]]; then
            systemctl start apache2 || log_error "Falha ao iniciar Apache."
            systemctl enable apache2 || log_warn "Falha ao habilitar Apache no boot."
        fi
    fi

    # Verifica se os arquivos estão no lugar
    if [[ -f "$WEB_ROOT/index.html" ]]; then
        log_success "Aplicação implantada em $WEB_ROOT"
    else
        log_warn "Arquivo index.html não encontrado em $WEB_ROOT."
    fi
}

# ─── Main ────────────────────────────────────────────────────────────────────
main() {
    parse_args "$@"

    echo -e "${BLUE}┌────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│  Provisionamento de Servidor Web — Linux Fundamentals  │${NC}"
    echo -e "${BLUE}│  Módulo 04: Serviços Linux e Infraestrutura como Código│${NC}"
    echo -e "${BLUE}└────────────────────────────────────────────────────────┘${NC}"
    echo ""

    [[ "$DRY_RUN" == true ]] && log_info "MODO DRY-RUN: nenhuma alteração será feita." && echo ""

    check_root
    system_update
    install_packages
    backup_existing
    deploy_application
    verify_installation

    echo ""
    echo -e "${GREEN}┌────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}│  Provisionamento concluído com sucesso!                │${NC}"
    echo -e "${GREEN}│  Acesse: http://localhost/                            │${NC}"
    echo -e "${GREEN}└────────────────────────────────────────────────────────┘${NC}"
}

main "$@"