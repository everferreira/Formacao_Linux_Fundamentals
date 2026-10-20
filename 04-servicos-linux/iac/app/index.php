<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aplicação PHP — Linux Fundamentals</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: #e0e0e0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 2.5rem;
            max-width: 640px;
            width: 90%;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        h1 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            background: linear-gradient(90deg, #00d2ff, #928dab);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .subtitle {
            font-size: 0.9rem;
            color: #888;
            margin-bottom: 1.5rem;
        }
        .info-card {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .info-label { color: #aaa; font-size: 0.85rem; }
        .info-value  { color: #fff; font-weight: 600; font-size: 0.95rem; }
        .status-ok {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .status-ok.success { background: rgba(0, 200, 83, 0.2); color: #00c853; }
        .status-ok.error   { background: rgba(255, 82, 82, 0.2); color: #ff5252; }
        footer {
            margin-top: 1.5rem;
            text-align: center;
            font-size: 0.8rem;
            color: #666;
        }
        footer a { color: #888; text-decoration: none; }
        footer a:hover { color: #00d2ff; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐧 Linux Fundamentals</h1>
        <p class="subtitle">Aplicação de Demonstração — Módulo 04</p>

        <?php
        // ─── Configuração do Banco de Dados ──────────────────────────────────
        // ATENÇÃO: Em produção, utilize variáveis de ambiente!
        $config = [
            'host'     => getenv('DB_HOST') ?: 'localhost',
            'username' => getenv('DB_USER') ?: 'root',
            'password' => getenv('DB_PASS') ?: 'Senha123',
            'database' => getenv('DB_NAME') ?: 'meubanco',
        ];

        // ─── Conexão com o Banco ─────────────────────────────────────────────
        $link = new mysqli($config['host'], $config['username'], $config['password'], $config['database']);

        if (mysqli_connect_errno()) {
            $db_status = 'Desconectado';
            $db_class  = 'error';
            $db_error  = mysqli_connect_error();
        } else {
            $db_status = 'Conectado';
            $db_class  = 'success';

            // Gera valores aleatórios
            $valor_rand1 = rand(1, 999);
            $valor_rand2 = strtoupper(substr(bin2hex(random_bytes(4)), 1));
            $host_name   = gethostname();

            // Insere registro
            $query = "INSERT INTO dados (AlunoID, Nome, Sobrenome, Endereco, Cidade, Host)
                      VALUES ('$valor_rand1', '$valor_rand2', '$valor_rand2',
                              '$valor_rand2', '$valor_rand2', '$host_name')";

            if ($link->query($query) === TRUE) {
                $insert_status = "Registro #$valor_rand1 inserido com sucesso!";
            } else {
                $insert_status = "Erro na inserção: " . $link->error;
            }
        }
        ?>

        <!-- Informações do Servidor -->
        <div class="info-card">
            <span class="info-label">PHP Version</span>
            <span class="info-value"><?= phpversion() ?></span>
        </div>
        <div class="info-card">
            <span class="info-label">Hostname</span>
            <span class="info-value"><?= gethostname() ?></span>
        </div>
        <div class="info-card">
            <span class="info-label">Database</span>
            <span class="status-ok <?= $db_class ?>"><?= $db_status ?></span>
        </div>
        <?php if (isset($db_error)): ?>
        <div class="info-card">
            <span class="info-label" style="color:#ff5252;">Erro DB</span>
            <span class="info-value" style="color:#ff5252;font-size:0.8rem;"><?= htmlspecialchars($db_error) ?></span>
        </div>
        <?php endif; ?>
        <?php if (isset($insert_status)): ?>
        <div class="info-card">
            <span class="info-label">Última Inserção</span>
            <span class="info-value" style="font-size:0.85rem;"><?= htmlspecialchars($insert_status) ?></span>
        </div>
        <?php endif; ?>

        <footer>
            <a href="https://github.com/everferreira/Formacao_Linux_Fundamentals" target="_blank">
                github.com/everferreira/Formacao_Linux_Fundamentals
            </a>
        </footer>
    </div>
</body>
</html>