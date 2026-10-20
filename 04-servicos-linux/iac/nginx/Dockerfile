# =============================================================================
#  Dockerfile — Servidor Nginx com Proxy Reverso
# =============================================================================
#  Descrição:
#    Imagem Docker para o servidor Nginx configurado como proxy reverso
#    com balanceamento de carga entre múltiplos servidores web.
#
#  Baseado na formação Linux Fundamentals (DIO) — Módulo 04.
#
#  Uso:
#    docker build -t nginx-lb:latest .
#    docker run -d -p 4500:4500 nginx-lb:latest
#
#  Autor: Ever Ferreira
#  Repositório: https://github.com/everferreira/Formacao_Linux_Fundamentals
# =============================================================================

FROM nginx:stable-alpine

# Remove a configuração padrão do Nginx
RUN rm -f /etc/nginx/conf.d/default.conf

# Copia a configuração personalizada com upstream de balanceamento
COPY nginx.conf /etc/nginx/nginx.conf

# Expõe a porta configurada no nginx.conf
EXPOSE 4500

# Health check para monitoramento do container
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://localhost:4500/ || exit 1