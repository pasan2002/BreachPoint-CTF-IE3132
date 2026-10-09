<?php
session_start();
if (isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true) {
    header('Location: dashboard.php');
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>NovaTech Corp – Admin Portal</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap');
    *{margin:0;padding:0;box-sizing:border-box}
    body{font-family:'Inter',sans-serif;background:#0a0e1a;display:flex;
         align-items:center;justify-content:center;min-height:100vh}
    .card{background:#0d1224;border:1px solid #1e2a45;border-radius:20px;
          padding:48px 40px;width:100%;max-width:420px;
          box-shadow:0 20px 60px rgba(0,0,0,.5)}
    .logo{text-align:center;margin-bottom:32px}
    .logo-icon{width:64px;height:64px;
               background:linear-gradient(135deg,#6366f1,#8b5cf6);
               border-radius:16px;margin:0 auto 14px;
               display:flex;align-items:center;justify-content:center;
               font-size:1.8rem}
    .logo h2{font-size:1.4rem;font-weight:800;color:#e2e8f0}
    .logo p{color:#475569;font-size:.85rem;margin-top:4px}
    .alert{background:#1a0d0d;border:1px solid #7f1d1d;color:#fca5a5;
           padding:12px 16px;border-radius:8px;margin-bottom:20px;font-size:.875rem}
    label{display:block;font-size:.85rem;font-weight:600;
          color:#94a3b8;margin-bottom:6px;margin-top:18px}
    input{width:100%;padding:12px 16px;background:#0a0e1a;
          border:1px solid #1e2a45;border-radius:8px;color:#e2e8f0;
          font-size:.95rem;font-family:inherit;transition:.2s}
    input:focus{outline:none;border-color:#6366f1;
                box-shadow:0 0 0 3px rgba(99,102,241,.2)}
    button{width:100%;margin-top:26px;padding:14px;
           background:linear-gradient(135deg,#6366f1,#8b5cf6);
           color:#fff;border:none;border-radius:8px;font-size:1rem;
           font-weight:700;cursor:pointer;transition:.3s;font-family:inherit}
    button:hover{transform:translateY(-1px);
                 box-shadow:0 8px 25px rgba(99,102,241,.4)}
    .badge{text-align:center;margin-top:20px;font-size:.8rem;
           color:#334155;padding:8px;background:#060a12;
           border-radius:6px;border:1px solid #0f172a}
  </style>
</head>
<body>
  <div class="card">
    <div class="logo">
      <div class="logo-icon">🔐</div>
      <h2>Admin Portal</h2>
      <p>NovaTech Corp Internal System</p>
    </div>

    <?php if (isset($_GET['error'])): ?>
      <div class="alert">⚠ Invalid credentials. Access denied.</div>
    <?php endif; ?>

    <form method="POST" action="login.php">
      <label for="username">Username</label>
      <input type="text" id="username" name="username"
             placeholder="Enter username" required autocomplete="off"/>
      <label for="password">Password</label>
      <input type="password" id="password" name="password"
             placeholder="Enter password" required/>
      <button type="submit">Sign In →</button>
    </form>

    <div class="badge">🔒 Authorised Personnel Only — NovaTech Corp © 2024</div>
  </div>
</body>
</html>