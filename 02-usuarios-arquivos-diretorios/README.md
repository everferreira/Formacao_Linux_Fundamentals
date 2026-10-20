# 👥 Módulo 02 — Usuários, Arquivos e Diretórios

<div align="center">

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Shell](https://img.shields.io/badge/Shell-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![GitHub](https://img.shields.io/badge/User%20Management-4444FF?style=for-the-badge)

</div>

## 🎯 Objetivos

- Gerenciar usuários, grupos e permissões no Linux
- Manipular arquivos e diretórios com maestria
- Compreender os níveis de permissão (rwx) e o esquema de ownership
- Automatizar o provisionamento de usuários com scripts IaC

---

## 📖 Resumo Conceitual

### O Modelo de Permissões Unix

No Linux, tudo é arquivo. Cada arquivo pertence a um **usuário** (owner) e a um **grupo**, e possui três níveis de permissão:

| Nível | Símbolo | Significado |
|-------|---------|-------------|
| **Owner** (u) | `rwx` | Dono do arquivo |
| **Group** (g) | `rwx` | Membros do grupo |
| **Others** (o) | `rwx` | Todos os demais |

**Valores octais:**

```
r = 4   w = 2   x = 1
rwx = 7   rw- = 6   r-x = 5   r-- = 4
```

### Tipos de Arquivos no `ls -la`

| Primeiro caractere | Tipo |
|:---:|------|
| `-` | Arquivo regular |
| `d` | Diretório |
| `l` | Link simbólico |
| `c` | Dispositivo de caractere |
| `b` | Dispositivo de bloco |

---

## 💻 Comandos Essenciais

### Gerenciamento de Usuários e Grupos

```bash
# ─── Usuários ────────────────────────────────────────────
useradd -m -s /bin/bash -G grupo usuario    # Criar com home + shell + grupo secundário
usermod -aG grupo usuario                   # Adicionar usuário a grupo (append)
passwd usuario                              # Definir/alterar senha
userdel -r usuario                          # Remover usuário + home + mail spool
id usuario                                  # Mostrar UID, GID e grupos do usuário
chage -l usuario                            # Ver políticas de expiração de senha

# ─── Grupos ──────────────────────────────────────────────
groupadd nome_grupo                         # Criar grupo
groupmod -n novo_nome nome_grupo            # Renomear grupo
groupdel nome_grupo                         # Remover grupo
gpasswd -a usuario grupo                    # Adicionar usuário a grupo
groups usuario                              # Listar grupos do usuário
```

### Permissões de Arquivos

```bash
# ─── Modificar permissões (modo simbólico) ───────────────
chmod u+x arquivo.sh         # Adiciona execução para o owner
chmod g-w arquivo.txt        # Remove escrita do grupo
chmod o+r arquivo.txt        # Adiciona leitura para outros
chmod a+x script.sh          # Adiciona execução para todos (ugo)
chmod u=rwx,g=rx,o= arquivo  # Define permissões exatas

# ─── Modificar permissões (modo octal) ───────────────────
chmod 755 script.sh          # Owner:rwx, Group:rx, Others:rx
chmod 644 README.md          # Owner:rw-, Group:r--, Others:r--
chmod 700 ~/.ssh             # Só o owner tem acesso
chmod 600 ~/.ssh/id_rsa      # Só o owner lê a chave privada

# ─── Ownership ────────────────────────────────────────────
chown usuario:grupo arquivo               # Altera owner e group
chown usuario: arquivo                    # Altera só o owner
chown :grupo arquivo                      # Altera só o group
chown -R usuario:grupo /pasta/            # Recursivo em diretórios

# ─── Permissões especiais ─────────────────────────────────
chmod u+s arquivo           # SUID — executa como dono do arquivo
chmod g+s diretorio         # SGID — novos arquivos herdam grupo
chmod +t /tmp               # Sticky bit — só dono pode deletar
```

### Manipulação Avançada de Arquivos

```bash
# ─── Busca (find) ─────────────────────────────────────────
find / -name "*.log" -type f 2>/dev/null        # Arquivos .log
find /home -user maria -mtime -7                 # Modificados nos últimos 7 dias
find /tmp -type f -size +100M -delete            # Arquivos > 100MB (cuidado!)
find . -perm 777 -type f                         # Arquivos com permissão total

# ─── Compactação ──────────────────────────────────────────
tar -czf backup.tar.gz /pasta                   # Compactar (gzip)
tar -xzf backup.tar.gz                          # Extrair
tar -cjf backup.tar.bz2 /pasta                  # Compactar (bzip2)

zip -r archive.zip /pasta                       # Compactar em ZIP
unzip archive.zip -d /destino                   # Extrair ZIP

# ─── Links ────────────────────────────────────────────────
ln -s /caminho/original link                    # Link simbólico (atalho)
ln /caminho/original link_hard                  # Link físico (hard link)
```

---

## 📜 Script de IaC: user-management.sh

O script [`scripts/user-management.sh`](scripts/user-management.sh) automatiza todo o provisionamento de usuários, grupos e permissões com tratamento profissional de erros.

**Funcionalidades:**

- ✅ Verificação de root com saída segura
- ✅ Criação idempotente (pula se já existe)
- ✅ Cores no output para legibilidade
- ✅ Funções modulares e bem documentadas
- ✅ Arrays para fácil customização

```bash
# Execute com:
sudo ./scripts/user-management.sh
```

### Estrutura do Script

```
main()
 ├── check_root()          # Verifica privilégios
 ├── setup_groups()        # Cria grupos: desenvolvedores, administradores
 ├── setup_users()         # Cria usuários: maria, joao, admin
 └── setup_directories()   # Cria pastas com permissões corretas
```

---

## 🧪 Troubleshooting & Boas Práticas

<details>
<summary>🔍 <b>Permissões clássicas e seus significados</b></summary>

| Permissão | Uso Típico |
|-----------|------------|
| `644` | Arquivos regulares (web, docs) |
| `755` | Diretórios e scripts executáveis |
| `600` | Chaves SSH, arquivos de senha |
| `700` | Diretórios pessoais `~` |
| `666` | ⚠️ Qualquer um pode escrever — evite! |
| `777` | ❌ Jamais! Qualquer um executa/escreve |

</details>

<details>
<summary>💡 <b>Dicas de segurança</b></summary>

- ⚠️ **Nunca use senhas em scripts** em produção — use vaults (Hashicorp Vault, AWS Secrets Manager)
- Prefira autenticação por **chave SSH** em vez de senhas
- Defina `umask 027` em servidores para evitar arquivos muito permissivos
- Use `chage` para expirar senhas temporárias: `chage -d 0 usuario`
- Revise regularmente: `awk -F: '($3 == 0)' /etc/passwd` (só root deve ter UID 0)

</details>

---

## 🔗 Navegação

| ← Anterior | Principal | Próximo → |
|:----------:|:---------:|:---------:|
| [Módulo 01: Introdução](../01-introducao-ao-linux/README.md) | [Voltar ao README](../README.md) | [Módulo 03: Pacotes e Discos](../03-gerenciamento-pacotes-discos/README.md) |

---

<div align="center">

*"Permissões no Linux não são burocracia — são a primeira linha de defesa do seu sistema."*

</div>