# 🚀 Módulo 04 — Serviços Linux e Infraestrutura como Código

<div align="center">

![Apache](https://img.shields.io/badge/Apache-D22128?style=for-the-badge&logo=apache&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)

</div>

## 🎯 Objetivos

- Provisionar servidores web (Apache) com scripts IaC profissionais
- Configurar proxy reverso e balanceamento de carga com Nginx
- Gerenciar bancos de dados MySQL/MariaDB
- Containerizar aplicações com Docker
- Integrar PHP com banco de dados em uma stack completa

---

## 📖 Resumo Conceitual

### Arquitetura da Stack

```
┌──────────────┐         ┌───────────────┐         ┌──────────────┐
│   Usuário    │ ──────> │  Nginx (LB)   │ ──────> │ Apache Web   │
│   (Browser)  │         │  Porta 4500   │         │ Server Pool  │
└──────────────┘         └───────────────┘         └──────┬───────┘
                                                          │
                                                          ▼
                                                  ┌──────────────┐
                                                  │  MySQL/Maria │
                                                  │  Database     │
                                                  └──────────────┘
```

O Módulo 04 é o coração prático da formação. Aqui, teoria encontra infraestrutura real: scripts que instalam servidores, configuram bancos, e orquestram containers — tudo versionado como código.

---

## 💻 Comandos Essenciais

### Apache HTTP Server

```bash
# ─── Instalação ────────────────────────────────────────────
sudo apt install apache2 -y

# ─── Gerenciamento ─────────────────────────────────────────
sudo systemctl status apache2          # Status
sudo systemctl enable --now apache2   # Habilita e inicia
sudo systemctl reload apache2          # Recarrega config (sem downtime)
sudo apachectl configtest              # Testa configuração

# ─── Configuração ──────────────────────────────────────────
# Sites habilitados: /etc/apache2/sites-enabled/
# Sites disponíveis: /etc/apache2/sites-available/
sudo a2ensite meusite.conf             # Habilita site
sudo a2dissite 000-default.conf        # Desabilita site
sudo a2enmod rewrite proxy ssl        # Habilita módulos
```

### Nginx (Proxy Reverso)

```bash
# ─── Instalação ────────────────────────────────────────────
sudo apt install nginx -y

# ─── Gerenciamento ─────────────────────────────────────────
sudo nginx -t                          # Testa configuração
sudo systemctl reload nginx            # Recarrega sem downtime
sudo systemctl restart nginx           # Reinicia

# ─── Proxy reverso ─────────────────────────────────────────
# Exemplo de location em nginx.conf:
# location /api/ {
#     proxy_pass http://localhost:8080/;
#     proxy_set_header Host $host;
#     proxy_set_header X-Real-IP $remote_addr;
# }
```

### Docker

```bash
# ─── Instalação ────────────────────────────────────────────
sudo apt install docker.io docker-compose-v2 -y
sudo usermod -aG docker $USER         # (reinicie o terminal)

# ─── Comandos essenciais ───────────────────────────────────
docker build -t minha-app:latest .     # Constrói imagem
docker run -d -p 80:80 minha-app       # Executa container
docker ps -a                           # Lista todos os containers
docker logs -f container_id            # Logs em tempo real
docker exec -it container_id bash      # Acessa o container
docker compose up -d                   # Sobe stack completa
```

---

## 📜 IaC: Scripts Refatorados

### 🔧 `iac/apache-provisioning.sh`

Script profissional de provisionamento Apache com:

| Funcionalidade | Descrição |
|----------------|-----------|
| `set -euo pipefail` | Modo estrito — falha rápido em qualquer erro |
| Cores no output | Logs com INFO/OK/WARN/ERROR coloridos |
| `--dry-run` | Simula sem modificar o sistema |
| `--force` | Reinstala pacotes (útil para refresh) |
| Backup automático | Preserva o conteúdo web existente |
| Verificação pós-setup | Confirma Apache ativo e arquivos no lugar |

```bash
# Simular (dry-run):
sudo ./iac/apache-provisioning.sh --dry-run

# Executar:
sudo ./iac/apache-provisioning.sh

# Reforçar instalação:
sudo ./iac/apache-provisioning.sh --force
```

### 🐳 `iac/nginx/` — Stack Docker

A stack Nginx está containerizada com Docker:

```bash
# Construir a imagem
cd iac/nginx
docker build -t nginx-lb:latest .

# Executar
docker run -d -p 4500:4500 nginx-lb:latest
```

A configuração [`nginx/nginx.conf`](iac/nginx/nginx.conf) implementa balanceamento round-robin com pesos entre três servidores upstream, headers de segurança e timeouts configurados.

### 🗄️ `iac/database/init.sql`

Schema MySQL otimizado para a aplicação PHP:

```sql
-- Cria banco com charset utf8mb4 (emoji-safe)
CREATE DATABASE IF NOT EXISTS meubanco
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Tabela com AUTO_INCREMENT e timestamps
CREATE TABLE IF NOT EXISTS dados (
    AlunoID   INT AUTO_INCREMENT PRIMARY KEY,
    Nome      VARCHAR(50) NOT NULL,
    Host      VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 🌐 `iac/app/index.php`

Aplicação PHP moderna com:
- Interface escura (glassmorphism) responsiva
- Status de conexão com o banco em tempo real
- Inserção de registros aleatórios com confirmação visual
- Suporte a variáveis de ambiente (`DB_HOST`, `DB_USER`, etc.)
- Design preparado para portfolio

---

## 🧪 Troubleshooting & Boas Práticas

<details>
<summary>🔍 <b>Problemas comuns</b></summary>

| Problema | Solução |
|----------|---------|
| Apache não inicia — porta 80 ocupada | `sudo lsof -i :80` e mate o processo conflitante |
| Nginx: `upstream` não resolvido | Verifique IPs no `nginx.conf` e conectividade |
| PHP: `Call to undefined function mysqli_connect()` | `sudo apt install php-mysql && sudo systemctl restart apache2` |
| Docker: `permission denied` | Saia e entre do terminal novamente (grupo docker) |
| MySQL: `Access denied for user` | Verifique senha e privilégios: `GRANT ALL ON meubanco.* TO 'root'@'localhost';` |

</details>

<details>
<summary>💡 <b>Boas práticas de IaC</b></summary>

- ✅ **Versionamento**: todo script deve estar no Git desde a primeira linha
- ✅ **Idempotência**: rodar duas vezes deve dar o mesmo resultado que rodar uma
- ✅ **Dry-run**: scripts destrutivos devem ter modo de simulação
- ✅ **Secrets**: nunca hardcode senhas — use variáveis de ambiente ou vaults
- ✅ **Health checks**: toda stack deve verificar se o serviço subiu corretamente
- ✅ **Logs**: scripts devem logar ações para auditoria

</details>

---

## 🔗 Navegação

| ← Anterior | Principal | Próximo → |
|:----------:|:---------:|:---------:|
| [Módulo 03: Pacotes e Discos](../03-gerenciamento-pacotes-discos/README.md) | [Voltar ao README](../README.md) | [Módulo 05: Linux Desktop Dev](../05-linux-desktop-dev/README.md) |

---

<div align="center">

*"Infraestrutura como Código não é sobre automatizar — é sobre confiar que o sistema vai funcionar às 3h da manhã."*

</div>