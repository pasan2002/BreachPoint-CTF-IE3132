<?php
session_start();
if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    header('Location: index.php');
    exit();
}
$username = htmlspecialchars($_SESSION['username']);

// Insecure Client-Side Session Role Check (OWASP A01: Broken Access Control)
$role = $_COOKIE['nova_role'] ?? 'guest';
$isAdmin = ($role === 'admin' || $role === 'administrator');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Dashboard – NovaTech Admin</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap');
    *{margin:0;padding:0;box-sizing:border-box}
    body{font-family:'Inter',sans-serif;background:#0a0e1a;color:#e2e8f0;min-height:100vh}
    header{display:flex;justify-content:space-between;align-items:center;
           padding:18px 40px;background:#0d1224;border-bottom:1px solid #1e2a45}
    .logo{font-size:1.2rem;font-weight:900;
          background:linear-gradient(135deg,#6366f1,#8b5cf6);
          -webkit-background-clip:text;-webkit-text-fill-color:transparent}
    .user-info{display:flex;gap:16px;align-items:center}
    .user-badge{background:#1e2a45;padding:8px 16px;
                border-radius:20px;font-size:.85rem;color:#94a3b8}
    .logout{color:#ef4444;text-decoration:none;font-size:.85rem;
            font-weight:600;padding:8px 16px;border:1px solid #7f1d1d;
            border-radius:8px;transition:.2s}
    .logout:hover{background:#7f1d1d22}
    main{padding:40px}
    .warning{background:#1a1a0d;border:1px solid #713f12;border-radius:10px;
             padding:16px 20px;color:#fbbf24;font-size:.875rem;
             margin-bottom:28px;display:flex;gap:10px;align-items:center}
    .denied-card{background:linear-gradient(135deg,#1f1212,#2d1515);
                 border:1px solid #991b1b;border-radius:16px;padding:28px;
                 margin-bottom:28px;text-align:center}
    .denied-title{font-size:1.1rem;font-weight:800;color:#f87171;margin-bottom:8px}
    .denied-msg{font-size:.9rem;color:#fca5a5;line-height:1.6}
    .flag-card{background:linear-gradient(135deg,#0f172a,#1e1b4b);
               border:1px solid #4338ca;border-radius:16px;padding:32px;
               margin-bottom:28px;text-align:center}
    .flag-label{font-size:.8rem;font-weight:700;color:#818cf8;
                letter-spacing:.1em;text-transform:uppercase;margin-bottom:12px}
    .flag-value{font-family:'Courier New',monospace;font-size:1.25rem;
                font-weight:700;color:#a5b4fc;background:#060a12;
                padding:14px 24px;border-radius:10px;
                border:1px solid #312e81;display:inline-block;letter-spacing:.05em}
    .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
          gap:20px;margin-bottom:28px}
    .stat{background:#0d1224;border:1px solid #1e2a45;border-radius:12px;padding:22px}
    .stat-label{font-size:.8rem;color:#475569;text-transform:uppercase;
                letter-spacing:.08em;margin-bottom:8px}
    .stat-value{font-size:1.8rem;font-weight:800;color:#6366f1}
    .section-title{font-size:1rem;font-weight:700;color:#94a3b8;
                   margin-bottom:16px;padding-left:4px}
    .backup-card{background:#0d1224;border:1px solid #1e2a45;border-radius:12px;
                 padding:22px 28px;display:flex;justify-content:space-between;
                 align-items:center}
    .backup-info h4{font-weight:700;margin-bottom:4px;font-size:.95rem}
    .backup-info p{color:#475569;font-size:.82rem}
    .dl-btn{padding:10px 22px;
            background:linear-gradient(135deg,#6366f1,#8b5cf6);
            color:#fff;border:none;border-radius:8px;text-decoration:none;
            font-weight:600;font-size:.9rem;transition:.3s;white-space:nowrap}
    .dl-btn:hover{transform:translateY(-1px);
                  box-shadow:0 6px 20px rgba(99,102,241,.4)}
  </style>
</head>
<body>
  <header>
    <div class="logo">NovaTech Corp — Admin</div>
    <div class="user-info">
      <span class="user-badge">👤 <?= $username ?> (Role: <?= htmlspecialchars(ucfirst($role)) ?>)</span>
      <a href="logout.php" class="logout">Sign Out</a>
    </div>
  </header>

  <main>
    <div class="warning">
      ⚠️ <strong>Security Notice:</strong>
      Internal maintenance console and secret keys are protected by role-based authorization controls.
    </div>

    <?php if ($isAdmin): ?>
      <!-- UNLOCKED FOR ELEVATED ROLE: admin / administrator -->
      <div class="flag-card">
        <div class="flag-label">🚩 Stage 3 Flag — Elevated Access (Administrator)</div>
        <div class="flag-value">BPCTF{4uth_p0rt4l_4cc3ss}</div>
      </div>
    <?php else: ?>
      <!-- RESTRICTED FOR ROLE: guest -->
      <div class="denied-card">
        <div class="denied-title">🚫 Restricted Privileges (Role: <?= htmlspecialchars($role) ?>)</div>
        <div class="denied-msg">
          Your current session role does not have authorization to view system secrets or access diagnostic utilities.<br/>
          <em>Administrative privileges (role: <code>admin</code>) are required to unlock maintenance utilities.</em>
        </div>
      </div>
    <?php endif; ?>

    <div class="grid">
      <div class="stat">
        <div class="stat-label">Active Users</div>
        <div class="stat-value">12</div>
      </div>
      <div class="stat">
        <div class="stat-label">Open Tickets</div>
        <div class="stat-value">3</div>
      </div>
      <div class="stat">
        <div class="stat-label">Deployments Today</div>
        <div class="stat-value">1</div>
      </div>
      <div class="stat">
        <div class="stat-label">Security Alerts</div>
        <div class="stat-value" style="color:#ef4444">7</div>
      </div>
    </div>

    <?php if ($isAdmin): ?>
      <div class="section-title">🔧 Admin Maintenance & System Tools</div>
      <div class="backup-card">
        <div class="backup-info">
          <h4>System Maintenance & Diagnostic Utility</h4>
          <p>Internal Server Diagnostic Tool & Remote System Backup Fetcher</p>
        </div>
        <a href="/files/" class="dl-btn" target="_blank">
          Launch Utility →
        </a>
      </div>
    <?php endif; ?>
  </main>
</body>
</html>