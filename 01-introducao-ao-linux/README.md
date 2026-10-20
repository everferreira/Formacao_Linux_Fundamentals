# 📘 Módulo 01 — Introdução ao Linux

<div align="center">

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Shell](https://img.shields.io/badge/Shell-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![SSH](https://img.shields.io/badge/SSH-000000?style=for-the-badge&logo=ssh&logoColor=white)

</div>

## 🎯 Objetivos

- Compreender a história e o ecossistema Linux
- Instalar e configurar uma distribuição Linux (máquina virtual, WSL, bare metal)
- Acessar remotamente servidores via SSH
- Navegar pelo sistema de arquivos usando o terminal
- Dominar os comandos fundamentais do dia a dia

---

## 📖 Resumo Conceitual

### O que é Linux?

Linux é um **kernel** criado por **Linus Torvalds** em 1991, sob licença **GPL** (código aberto). Diferente do Windows e macOS, o Linux é modular: o kernel gerencia hardware e recursos, enquanto distribuições (distros) empacotam o kernel com ferramentas GNU, gerenciadores de pacotes, interfaces gráficas e aplicações.

### Distribuições Populares

| Distribuição | Família | Gerenciador | Uso Típico |
|--------------|---------|-------------|------------|
| **Ubuntu** | Debian | `apt` | Desktop, Servidor, Cloud |
| **Debian** | Debian | `apt` | Servidor (estabilidade) |
| **Fedora** | Red Hat | `dnf` | Desktop, Desenvolvimento |
| **CentOS / Rocky** | Red Hat | `yum` / `dnf` | Servidor Corporativo |
| **Arch Linux** | Independente | `pacman` | Rolling release, DIY |

### Sistema de Arquivos (FHS)

O Linux segue o **Filesystem Hierarchy Standard (FHS)**:

| Diretório | Finalidade |
|-----------|------------|
| `/` | Raiz do sistema |
| `/bin` | Binários essenciais do sistema |
| `/sbin` | Binários administrativos (root) |
| `/etc` | Arquivos de configuração |
| `/var` | Dados variáveis (logs, filas) |
| `/tmp` | Arquivos temporários |
| `/home` | Diretórios pessoais dos usuários |
| `/root` | Diretório do usuário root |
| `/usr` | Programas e bibliotecas do usuário |
| `/opt` | Software opcional de terceiros |

---

## 💻 Comandos Essenciais

### Navegação

```bash
pwd                        # Mostra o diretório atual
ls -la                     # Lista arquivos detalhados (inclusive ocultos)
ls -lh                     # Lista com tamanhos legíveis
cd /caminho/para/pasta     # Navega para o diretório
cd ~                       # Vai para o home do usuário
cd -                       # Volta ao diretório anterior
tree .                     # (se instalado) Exibe árvore de diretórios
```

### Manipulação de Arquivos

```bash
touch arquivo.txt          # Cria arquivo vazio (ou atualiza timestamp)
cat arquivo.txt            # Exibe conteúdo na tela
less arquivo.txt           # Exibe com paginação (seta/n, q para sair)
head -n 20 arquivo.txt     # Mostra as primeiras 20 linhas
tail -f arquivo.log        # Monitora o final do arquivo em tempo real
cp -r origem/ destino/     # Copia recursivamente
mv arquivo.txt novo.txt    # Move / renomeia
rm -rf pasta/              # Remove recursivamente com força ⚠️
```

### Consulta e Ajuda

```bash
man ls                     # Manual completo do comando (pressione 'q' para sair)
ls --help                  # Ajuda resumida embutida
whatis ls                  # Descrição de uma linha sobre o comando
apropos "compress"         # Busca comandos relacionados a um tema
type comando               # Mostra o tipo do comando (built-in, alias, binário)
```

### Monitoramento do Sistema

```bash
uname -a                   # Informações completas do kernel
df -h                      # Espaço em disco em formato legível
free -h                    # Memória RAM usada/livre
uptime                     # Tempo ligado + carga média
whoami                     # Nome do usuário atual
hostname                   # Nome da máquina
```

---

## 🔐 Acesso Remoto (SSH)

### Conexão Básica

```bash
# Conectar a um servidor remoto
ssh usuario@192.168.1.100

# Especificar porta não padrão
ssh -p 2222 usuario@servidor.com

# Usar chave privada específica
ssh -i ~/.ssh/minha-chave.pem usuario@ec2.amazonaws.com
```

### Par de Chaves SSH

```bash
# Gerar chave RSA de 4096 bits
ssh-keygen -t rsa -b 4096 -C "seu@email.com"

# Copiar chave pública para o servidor
ssh-copy-id usuario@servidor.com

# Ou manualmente:
cat ~/.ssh/id_rsa.pub | ssh usuario@servidor "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### Boas Práticas de Segurança SSH

```bash
# No servidor, edite /etc/ssh/sshd_config:
#   Port 2222                    # Mude a porta padrão
#   PermitRootLogin no           # Desabilite login como root
#   PasswordAuthentication no    # Só autenticação por chave
#   PubkeyAuthentication yes     # Habilite chave pública

# Reinicie o serviço após alterações
sudo systemctl restart sshd
```

---

## 🧪 Troubleshooting & Boas Práticas

<details>
<summary>🔍 <b>Problemas comuns e soluções</b></summary>

| Problema | Causa Provável | Solução |
|----------|---------------|---------|
| `Permission denied (publickey)` | Chave SSH não autorizada | Use `ssh-copy-id` ou verifique `~/.ssh/authorized_keys` |
| `Connection refused` | SSH não está rodando | `sudo systemctl start sshd` |
| Comando não encontrado | Pacote não instalado ou PATH incorreto | `which comando` para depurar |
| Disco cheio | Logs ou arquivos grandes | `du -sh /* | sort -rh | head -10` |
| `sudo: command not found` | Sem privilégios ou sudo não instalado | Execute como root: `su -` |

</details>

<details>
<summary>💡 <b>Dicas de produtividade</b></summary>

- `Ctrl+R` — Busca reversa no histórico de comandos
- `Ctrl+A` / `Ctrl+E` — Início / fim da linha
- `Ctrl+U` / `Ctrl+K` — Apaga até o início / fim da linha
- `Alt+.` — Insere o último argumento do comando anterior
- `!!` — Repete o último comando (`sudo !!` para repetir com sudo)
- Use **aliases** no `~/.bashrc` para comandos frequentes

```bash
# Exemplos de aliases úteis
alias ll='ls -lah'
alias la='ls -A'
alias grep='grep --color=auto'
alias ..='cd ..'
```

</details>

---

## 🔗 Navegação

| ← Anterior | Principal | Próximo → |
|:----------:|:---------:|:---------:|
| — | [Voltar ao README](../README.md) | [Módulo 02: Usuários, Arquivos e Diretórios](../02-usuarios-arquivos-diretorios/README.md) |

---

<div align="center">

*"O Linux é como um canivete suíço: você só precisa conhecer as ferramentas certas para cada problema."*

</div>