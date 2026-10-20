-- =============================================================================
--  init.sql — Script de Inicialização do Banco de Dados (Aplicação PHP)
-- =============================================================================
--  Descrição:
--    Cria a estrutura de tabelas para a aplicação PHP de demonstração,
--    que registra acessos com dados aleatórios e informações do host.
--
--  Baseado no módulo "Serviços Linux e Infraestrutura como Código" da
--  formação Linux Fundamentals (DIO).
--
--  Uso:
--    mysql -u root -p < init.sql
--
--  Autor: Ever Ferreira
--  Repositório: https://github.com/everferreira/Formacao_Linux_Fundamentals
-- =============================================================================

-- Cria o banco de dados caso não exista
CREATE DATABASE IF NOT EXISTS meubanco
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE meubanco;

-- Tabela de registros de acesso
CREATE TABLE IF NOT EXISTS dados (
    AlunoID   INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador único do registro',
    Nome      VARCHAR(50)  NOT NULL COMMENT 'Nome ou identificador gerado aleatoriamente',
    Sobrenome VARCHAR(50)  NOT NULL COMMENT 'Sobrenome ou hash aleatório',
    Endereco  VARCHAR(150) DEFAULT NULL COMMENT 'Endereço fictício',
    Cidade    VARCHAR(50)  DEFAULT NULL COMMENT 'Cidade fictícia',
    Host      VARCHAR(50)  NOT NULL COMMENT 'Hostname do servidor que inseriu o registro',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp de criação'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Concede privilégios básicos ao usuário da aplicação
-- (Descomente e ajuste conforme necessário)
-- GRANT ALL PRIVILEGES ON meubanco.* TO 'app_user'@'localhost' IDENTIFIED BY 'sua_senha_aqui';
-- FLUSH PRIVILEGES;