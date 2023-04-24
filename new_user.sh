#!/bin/bash

# Criação de grupos
groupadd desenvolvedores
groupadd administradores

# Criação de usuários
useradd -m -s /bin/bash -G desenvolvedores maria
useradd -m -s /bin/bash -G desenvolvedores joao
useradd -m -s /bin/bash -G administradores admin

# Definição de senhas para os usuários
echo "senha123" | passwd --stdin maria
echo "senha456" | passwd --stdin joao
echo "senha789" | passwd --stdin admin

# Criação de diretórios
mkdir /home/maria/arquivos
mkdir /home/joao/projetos
mkdir /home/admin/documentos

# Definição de permissões
chown maria:desenvolvedores /home/maria/arquivos
chmod 770 /home/maria/arquivos

chown joao:desenvolvedores /home/joao/projetos
chmod 770 /home/joao/projetos

chown admin:administradores /home/admin/documentos
chmod 770 /home/admin/documentos
