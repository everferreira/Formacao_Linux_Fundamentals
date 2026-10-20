<div align="center">

# 🐧 Formação Linux Fundamentals

### `Do Zero ao DevOps — Infraestrutura como Código, Scripts e Serviços`

[![GitHub last commit](https://img.shields.io/github/last-commit/everferreira/Formacao_Linux_Fundamentals?style=for-the-badge&color=blueviolet)](https://github.com/everferreira/Formacao_Linux_Fundamentals/commits/main)
[![GitHub repo size](https://img.shields.io/github/repo-size/everferreira/Formacao_Linux_Fundamentals?style=for-the-badge&color=blueviolet)](https://github.com/everferreira/Formacao_Linux_Fundamentals)
[![License](https://img.shields.io/badge/license-MIT-blueviolet?style=for-the-badge)](LICENSE)
[![Made with](https://img.shields.io/badge/Made%20with-Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Apache](https://img.shields.io/badge/Apache-D22128?style=for-the-badge&logo=apache&logoColor=white)](https://httpd.apache.org/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net/)

</div>

---

## 📋 Sobre

Este repositório documenta minha jornada na **Formação Linux Fundamentals** da [Digital Innovation One (DIO)](https://www.dio.me/), revisitada e elevada com o olhar de quem hoje trabalha com **infraestrutura moderna, automação e Cloud**.

Cada módulo foi reescrito como um **manual de batalha** — não apenas anotações de curso, mas conteúdo curado com:
- Comandos comentados com o *porquê* de cada flag
- Boas práticas de segurança e performance
- Scripts de IaC com tratamento de erros
- Infraestrutura containerizada (Docker + Nginx + PHP + MySQL)

---

## 🗺️ Navegação Rápida

<table align="center">
  <thead>
    <tr>
      <th width="40">#</th>
      <th width="280">Módulo</th>
      <th width="120">Status</th>
      <th width="160">Destaques</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">01</td>
      <td><a href="01-introducao-ao-linux/README.md"><b>Introdução ao Linux</b></a><br><sub>Fundamentos, Instalação, SSH</sub></td>
      <td align="center">✅ Completo</td>
      <td align="center">FHS · Terminal · WSL</td>
    </tr>
    <tr>
      <td align="center">02</td>
      <td><a href="02-usuarios-arquivos-diretorios/README.md"><b>Usuários, Arquivos e Diretórios</b></a><br><sub>Manipulação, Permissões, Grupos</sub></td>
      <td align="center">✅ Completo</td>
      <td align="center">📜 <code>user-management.sh</code></td>
    </tr>
    <tr>
      <td align="center">03</td>
      <td><a href="03-gerenciamento-pacotes-discos/README.md"><b>Gerenciamento de Pacotes e Discos</b></a><br><sub>APT, Partições, Processos</sub></td>
      <td align="center">✅ Completo</td>
      <td align="center">systemd · LVM · fstab</td>
    </tr>
    <tr>
      <td align="center">04</td>
      <td><a href="04-servicos-linux/README.md"><b>Serviços Linux & IaC</b></a><br><sub>Apache, Nginx, Docker, Banco de Dados</sub></td>
      <td align="center">✅ Completo</td>
      <td align="center">🐳 Docker · 📜 <code>apache-provisioning.sh</code></td>
    </tr>
    <tr>
      <td align="center">05</td>
      <td><a href="05-linux-desktop-dev/README.md"><b>Linux Desktop para Devs</b></a><br><sub>Vim, Git, Docker Desktop, WSL2</sub></td>
      <td align="center">✅ Completo</td>
      <td align="center">Vim · Git · Dev Tools</td>
    </tr>
  </tbody>
</table>

---

## 🏗️ Arquitetura do Projeto

```
📦 Formacao_Linux_Fundamentals
 ┣ 📂 01-introducao-ao-linux/         # Fundamentos, instalação e SSH
 ┃ ┗ 📜 README.md                      # Manual do módulo 01
 ┣ 📂 02-usuarios-arquivos-diretorios/ # Usuários, grupos, permissões
 ┃ ┣ 📜 README.md
 ┃ ┗ 📂 scripts/
 ┃   ┗ 📜 user-management.sh           # IaC: provisionamento de usuários
 ┣ 📂 03-gerenciamento-pacotes-discos/  # APT, partições, processos
 ┃ ┗ 📜 README.md
 ┣ 📂 04-servicos-linux/               # Servidores, Docker, IaC
 ┃ ┣ 📜 README.md
 ┃ ┣ 📂 iac/
 ┃ ┃ ┣ 📜 apache-provisioning.sh       # IaC: Apache + deploy de app
 ┃ ┃ ┣ 📂 nginx/
 ┃ ┃ ┃ ┣ 📜 Dockerfile                 # Nginx LB containerizado
 ┃ ┃ ┃ ┗ 📜 nginx.conf                 # Config de balanceamento
 ┃ ┃ ┣ 📂 database/
 ┃ ┃ ┃ ┗ 📜 init.sql                   # Schema MySQL/MariaDB
 ┃ ┃ ┗ 📂 app/
 ┃ ┃   ┗ 📜 index.php                  # App PHP com conexão ao DB
 ┗ 📂 05-linux-desktop-dev/            # Ferramentas do desenvolvedor
   ┗ 📜 README.md
```

---

## 🛠️ Tecnologias e Ferramentas

<div align="center">

| Categoria | Tecnologias |
|-----------|-------------|
| **Sistema** | GNU/Linux (Debian/Ubuntu, RHEL), WSL2 |
| **Shell** | Bash, Scripts, AWK, Sed |
| **Web Server** | Apache2, Nginx (proxy reverso + LB) |
| **Container** | Docker, Docker Compose |
| **Banco de Dados** | MySQL, MariaDB |
| **Linguagens** | PHP, SQL, Shell Script |
| **Versionamento** | Git, GitHub |
| **Editores** | Vim, VS Code |

</div>

---

## 🚀 Como Usar

```bash
# Clone o repositório
git clone https://github.com/everferreira/Formacao_Linux_Fundamentals.git
cd Formacao_Linux_Fundamentals

# Explore os módulos na ordem sugerida
# Cada README tem teoria + comandos + exercícios

# Execute os scripts IaC (requer sudo)
sudo chmod +x 02-usuarios-arquivos-diretorios/scripts/user-management.sh
sudo ./02-usuarios-arquivos-diretorios/scripts/user-management.sh

sudo chmod +x 04-servicos-linux/iac/apache-provisioning.sh
sudo ./04-servicos-linux/iac/apache-provisioning.sh

# Suba a stack Docker com Nginx + PHP + MySQL
cd 04-servicos-linux/iac
docker compose up -d  # (em breve)
```

---

## 📊 Estatísticas do Repositório

<div align="center">

![GitHub stars](https://img.shields.io/github/stars/everferreira/Formacao_Linux_Fundamentals?style=flat-square&color=yellow)
![GitHub forks](https://img.shields.io/github/forks/everferreira/Formacao_Linux_Fundamentals?style=flat-square&color=blue)
![GitHub watchers](https://img.shields.io/github/watchers/everferreira/Formacao_Linux_Fundamentals?style=flat-square&color=red)

</div>

---

## 📜 Licença

Distribuído sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais informações.

---

<div align="center">

**Feito com 🐧 por [Ever Ferreira](https://github.com/everferreira)**

*Linux Fundamentals — DIO* · *De estudante a profissional*

</div>