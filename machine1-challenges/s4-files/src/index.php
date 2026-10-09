<?php
$output = '';
$host = $_GET['host'] ?? '';

if (!empty($host)) {
    $cmd = "ping -c 2 " . $host;
    $output = shell_exec($cmd . " 2>&1");
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>NovaTech Corp – System Maintenance Tool</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap');
    *{margin:0;padding:0;box-sizing:border-box}
    body{font-family:'Inter',sans-serif;background:#0a0e1a;color:#e2e8f0;padding:40px;min-height:100vh}
    .card{background:#0d1224;border:1px solid #1e2a45;border-radius:16px;padding:32px;max-width:800px;margin:0 auto;box-shadow:0 20px 60px rgba(0,0,0,.5)}
    h2{color:#6366f1;margin-bottom:8px;font-weight:800}
    p{color:#94a3b8;font-size:.9rem;margin-bottom:24px}
    form{display:flex;gap:12px;margin-bottom:24px}
    input[type="text"]{flex:1;padding:12px 16px;background:#0a0e1a;border:1px solid #1e2a45;border-radius:8px;color:#e2e8f0;font-size:.95rem}
    button{padding:12px 24px;background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;border-radius:8px;font-size:1rem;font-weight:700;cursor:pointer}
    .terminal{background:#060a12;border:1px solid #1e2a45;border-radius:10px;padding:20px;font-family:'Courier New',monospace;color:#38bdf8;white-space:pre-wrap;overflow-x:auto;min-height:150px}
    .hint{margin-top:20px;font-size:.8rem;color:#475569;border-top:1px solid #1e2a45;padding-top:12px}
  </style>
</head>
<body>
  <div class="card">
    <h2>🛠 NovaTech System Diagnostics</h2>
    <p>Internal ping & network health utility for NovaTech sysadmins.</p>

    <form method="GET" action="">
      <input type="text" name="host" placeholder="Enter IP or hostname (e.g. 127.0.0.1)" value="<?= htmlspecialchars($host) ?>" required/>
      <button type="submit">Execute Ping</button>
    </form>

    <div class="terminal"><?= !empty($output) ? htmlspecialchars($output) : "System console ready. Enter a target address above." ?></div>

    <!-- Sysadmin Note: In compliance with security policy, all server configuration backups have been relocated to /opt/backups/ -->
    <div class="hint">
      🔒 Internal Maintenance Console v2.4 | Automated system backup repository: <code>/opt/backups/</code>
    </div>
  </div>
</body>
</html>