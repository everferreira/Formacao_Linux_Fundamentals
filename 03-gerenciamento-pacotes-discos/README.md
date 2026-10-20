# 📦 Módulo 03 — Gerenciamento de Pacotes e Discos

<div align="center">

![APT](https://img.shields.io/badge/APT-6C6C6C?style=for-the-badge&logo=debian&logoColor=white)
![Discos](https://img.shields.io/badge/Disk%20Management-FF5722?style=for-the-badge&logo=files&logoColor=white)
![Systemd](https://img.shields.io/badge/Systemd-008000?style=for-the-badge&logo=systemd&logoColor=white)

</div>

## 🎯 Objetivos

- Gerenciar pacotes com APT (Debian/Ubuntu)
- Compreender particionamento de discos e sistemas de arquivos
- Montar e desmontar partições manualmente e via `fstab`
- Controlar processos e serviços com systemd

---

## 📖 Resumo Conceitual

### Gerenciamento de Pacotes

No ecossistema Linux, cada família de distribuições tem seu próprio sistema de pacotes:

| Família | Gerenciador | Formato | Comando |
|---------|-------------|---------|---------|
| **Debian/Ubuntu** | APT (dpkg) | `.deb` | `apt`, `apt-get`, `dpkg` |
| **Red Hat/Fedora** | DNF (RPM) | `.rpm` | `dnf`, `yum`, `rpm` |
| **Arch Linux** | Pacman | — | `pacman` |
| **openSUSE** | Zypper (RPM) | `.rpm` | `zypper` |

### Particionamento de Discos

O Linux enxerga discos como arquivos de dispositivo em `/dev/`:

| Dispositivo | Tipo | Exemplo |
|-------------|------|---------|
| `/dev/sda` | SATA/SAS | Disco principal |
| `/dev/nvme0n1` | NVMe | SSD NVMe |
| `/dev/vda` | VirtIO | VM na nuvem |
| `/dev/mmcblk0` | eMMC/SD | Cartão SD |

**Esquemas de Partição:**
- **MBR** — Master Boot Record (até 2TB, 4 primárias)
- **GPT** — GUID Partition Table (>2TB, ilimitadas, UEFI)

---

## 💻 Comandos Essenciais

### APT — Advanced Package Tool

```bash
# ─── Atualização e pesquisa ───────────────────────────────
sudo apt update                    # Atualiza lista de pacotes
sudo apt upgrade -y                # Atualiza pacotes instalados
sudo apt full-upgrade              # Atualiza com remoção se necessário
sudo apt autoremove                # Remove pacotes órfãos
apt search "nginx"                 # Busca pacotes
apt show nginx                     # Mostra detalhes do pacote

# ─── Instalação e remoção ─────────────────────────────────
sudo apt install nginx php mariadb-server  # Instala múltiplos pacotes
sudo apt remove nginx               # Remove (mantém configs)
sudo apt purge nginx                # Remove completamente
sudo apt install ./pacote.deb       # Instala .deb local
sudo dpkg -i pacote.deb             # Instala com dpkg (baixo nível)
sudo dpkg -l | grep nginx           # Lista pacotes instalados

# ─── Repositórios PPAs ────────────────────────────────────
sudo add-apt-repository ppa:deadsnakes/ppa    # Adiciona PPA
sudo add-apt-repository --remove ppa:deadsnakes/ppa  # Remove PPA
```

### Discos e Partições

```bash
# ─── Identificação ─────────────────────────────────────────
lsblk                       # Árvore de dispositivos de bloco
lsblk -f                    # Mostra sistemas de arquivos e UUIDs
sudo fdisk -l               # Lista partições completas
sudo blkid                  # UUIDs e labels de todas as partições
sudo parted -l              # Informações detalhadas

# ─── Particionamento (cuidado!) ────────────────────────────
sudo fdisk /dev/sdb         # Particionador interativo
# Comandos do fdisk: m=ajuda, n=nova, d=delete, w=salvar, q=sair

# ─── Formatação ────────────────────────────────────────────
sudo mkfs.ext4 /dev/sdb1    # Formata em ext4
sudo mkfs.xfs /dev/sdb2     # Formata em XFS
sudo mkswap /dev/sdb3       # Formata como swap
sudo swapon /dev/sdb3       # Ativa swap

# ─── Montagem ──────────────────────────────────────────────
sudo mount /dev/sdb1 /mnt/dados        # Monta manual
sudo umount /mnt/dados                 # Desmonta
sudo mount -a                          # Monta tudo do /etc/fstab

# ─── fstab — Montagem permanente ───────────────────────────
# Formato: <device> <mountpoint> <fstype> <options> <dump> <pass>
# UUID=xxxx-xxxx    /mnt/dados    ext4    defaults    0    2
# Use UUIDs em vez de /dev/sdX (mudam entre reboots!)
sudo blkid /dev/sdb1        # Para obter o UUID
```

### Processos e Serviços

```bash
# ─── Processos (ps e top) ──────────────────────────────────
ps aux                      # Todos os processos (BSD)
ps -ef                      # Todos os processos (System V)
ps aux --sort=-%mem | head -10  # Top 10 por memória
top                         # Monitor interativo (pressione q para sair)
htop                        # Versão melhorada (instalar: sudo apt install htop)
kill -15 PID                # SIGTERM — pede finalização graciosa
kill -9 PID                 # SIGKILL — força finalização ⚠️
pkill -f "nome"             # Mata por nome/pattern

# ─── Systemd ────────────────────────────────────────────────
sudo systemctl status apache2          # Status do serviço
sudo systemctl start apache2           # Inicia
sudo systemctl stop apache2            # Para
sudo systemctl restart apache2         # Reinicia
sudo systemctl enable apache2          # Habilita no boot
sudo systemctl disable apache2         # Desabilita no boot
sudo systemctl daemon-reload           # Recarrega unit files (após alterações)

# ─── Logs ──────────────────────────────────────────────────
journalctl -u apache2                  # Logs de um serviço
journalctl -u apache2 -n 50            # Últimas 50 linhas
journalctl -u apache2 -f               # Segue em tempo real
journalctl --disk-usage                # Espaço ocupado pelos logs
sudo journalctl --vacuum-size=200M     # Limita tamanho dos logs
```

---

## 🧪 Troubleshooting & Boas Práticas

<details>
<summary>🔍 <b>Problemas comuns</b></summary>

| Problema | Causa | Solução |
|----------|-------|---------|
| `dpkg: error processing package` | Pacote corrompido | `sudo dpkg --configure -a` |
| `Could not get lock /var/lib/dpkg/lock` | Outro apt rodando | `sudo killall apt` ou remova o lock file |
| Disco `/dev/sdb1` não monta | UUID mudou | Atualize `/etc/fstab` com o UUID atual |
| `Permission denied` ao montar | Sem sudo | Use `sudo mount` ou adicione ao `/etc/fstab` com `users` |
| Serviço não sobe na porta 80 | Porta ocupada | `sudo lsof -i :80` para identificar o processo |

</details>

<details>
<summary>💡 <b>Boas práticas</b></summary>

- ✅ **Sempre use UUIDs** no `fstab` em vez de `/dev/sdX`
- ✅ Faça `apt update && apt upgrade` regularmente
- ✅ Antes de alterar partições, faça **backup dos dados**
- ✅ Use `screen` ou `tmux` para operações longas (particionamento remoto)
- ✅ Configure `logrotate` para evitar logs acumularem espaço
- ✅ Teste montagens com `mount -a` antes de reiniciar

```bash
# Exemplo de /etc/fstab otimizado:
UUID=abc123  /              ext4    defaults,noatime    0  1
UUID=def456  /mnt/dados     ext4    defaults,noatime    0  2
UUID=ghi789  swap           swap    sw                  0  0
tmpfs        /tmp           tmpfs   defaults,noexec,size=2G  0  0
```

</details>

---

## 🔗 Navegação

| ← Anterior | Principal | Próximo → |
|:----------:|:---------:|:---------:|
| [Módulo 02: Usuários e Arquivos](../02-usuarios-arquivos-diretorios/README.md) | [Voltar ao README](../README.md) | [Módulo 04: Serviços Linux & IaC](../04-servicos-linux/README.md) |

---

<div align="center">

*"Um sysadmin que não entende de discos é como um piloto que não entende de combustível."*

</div>