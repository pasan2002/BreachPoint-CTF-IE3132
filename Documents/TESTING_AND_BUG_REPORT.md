# BreachPoint CTF — Quality Assurance & Testing Report
**Document ID:** `BP-QA-REP-V2.1`  
**Author:** Haggalla H.H.D.S (Member 4 — Integration, Testing & Documentation)  
**Student ID:** `IT24100975`  
**Module:** IE3132 — Penetration Testing & Ethical Hacking (Assignment 02)  
**Target Platform:** BreachPoint CTF (6 Stages, 1,550 Total Points)  
**Host Architecture:** Machine 1 (Port 80 Nginx Proxy & Port 2222 SSH) | Machine 2 (Port 8000 CTFd)  
**Status:** **100% Passing — Verified Against Production Containers & Source Code**

---

## 1. Executive QA Summary & Scope

As Member 4, the primary responsibilities are end-to-end integration, flaw identification, defect fixing, unintended shortcut prevention, and comprehensive documentation.

This report documents the verification of the **16-item Pre-CTF System Validation Checklist** originally committed in Assignment 01, the formal test cases (**TC-01 through TC-08**), the bug tracking matrix (**BUG-01 through BUG-05**), and the execution of the automated end-to-end LO3 validation script (`validate_killchain_e2e.py`).

### Key Testing Metrics
- **Total Test Cases Executed:** 8 (TC-01 through TC-08)
- **Defects Identified:** 5 (BUG-01 through BUG-05)
- **Defects Resolved & Retested:** 5 (100% resolution)
- **Unintended Solution Shortcuts Prevented:** 4
- **Automated Validation Status:** **PASS** (Cryptographic baseline verified via `validate_killchain_e2e.py`)

---

## 2. Actual Network Topology & Stage Mapping

All web stages are containerized and routed exclusively through an **Nginx Reverse Proxy on Port 80**, while lateral movement transitions to **Port 2222** for the Linux environment:

| Component | Port / Access Path | Container Name | Target Function & Exploitation Flow |
| :--- | :--- | :--- | :--- |
| **Nginx Reverse Proxy** | `80/TCP` (Public) | `nginx-proxy` | Routes path-based HTTP requests (`/`, `/api/`, `/novatech-portal/`, `/files/`) to internal challenge containers. |
| **Stage 1: Open Eyes** | `80/TCP` (`/`) | `s1-web` | Corporate portal (`about.html` exposes Flag Part 1; `novatech_logo.png` EXIF metadata exposes Flag Part 2). |
| **Stage 2: Knock Knock** | `80/TCP` (`/api/`) | `s2-api` | Hidden REST API endpoint discovered via Gobuster; leaks credentials and Stage 2 flag. |
| **Stage 3: The Login Wall** | `80/TCP` (`/novatech-portal/`) | `s3-portal` | Employee portal backed by MySQL (`s3-db`); client-side cookie `nova_role=guest` manipulated to `admin`. |
| **Stage 4: Scrambled Secrets** | `80/TCP` (`/files/`) | `s4-files` | Network diagnostic ping tool vulnerable to command injection; exfiltrates `/opt/backups/config_backup.enc`. |
| **Stage 5: Dead Logs** | `2222/TCP` (SSH) | `s5s6-ssh` | Encrypted archive `/tmp/suspicious.zip` cracked with John the Ripper (`shadow123`) to extract `notes.txt`. |
| **Stage 6: Root of Evil** | `2222/TCP` (SSH) | `s5s6-ssh` | Vulnerable SUID binary `/usr/local/bin/reader` executing `less`; GTFOBins breakout to root for `/root/flag.txt`. |

---

## 3. Defect Tracking Matrix (Bugs Found & Fixed)

The following matrix records all defects discovered during the integration testing phase, their technical root causes, the code fixes applied, and their post-mitigation statuses:

| Bug ID | Stage Affected | Defect Description | Severity | Fix Implemented | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **BUG-01** | Stage 1 | Entire flag was exposed in a single visible HTML comment on `index.html`. | **High** | Split flag into two parts: Part 1 in `about.html` protected by JS contextmenu/Ctrl+U blockers; Part 2 embedded in `novatech_logo.png` EXIF metadata. | **VERIFIED CLOSED** |
| **BUG-02** | Stage 2 | API endpoint ran on an unrouted port with zero architecture integration. | **Medium** | Configured `nginx-proxy/nginx.conf` to route `location /api/` internally to `s2-api`, requiring Gobuster / dirb directory fuzzing. | **VERIFIED CLOSED** |
| **BUG-03** | Stage 3 | Valid credentials immediately displayed flag with zero role verification. | **Critical** | Modified `login.php` to issue a low-privilege `nova_role=guest` cookie; `dashboard.php` now strictly requires cookie elevation to `nova_role=admin`. | **VERIFIED CLOSED** |
| **BUG-04** | Stage 4 | `config_backup.enc` located inside web root (`/var/www/html/backups/`), allowing direct download bypass. | **High** | In `Dockerfile`, moved backup to `/opt/backups/` and deleted `/var/www/html/backups/`. Forces command injection: `127.0.0.1; cat /opt/backups/config_backup.enc`. | **VERIFIED CLOSED** |
| **BUG-05** | Stage 5 | Cleartext key `/home/deploy/.secret_key` left in container build, bypassing password cracking. | **Critical** | Commented out `.secret_key` creation in `setup.sh`; enforced legitimate offline dictionary cracking using `zip2john` and John the Ripper (`rockyou.txt`). | **VERIFIED CLOSED** |

---

## 4. Formal Test Cases (TC-01 through TC-08)

### TC-01: Stage 1 — Source Inspection Barrier & HTML Clue Extraction
- **Target Stage & Focus:** Stage 1 (Open Eyes - Reconnaissance / OSINT)
- **Test Objective:** Verify that direct browser inspection shortcuts (right-click, `Ctrl+U`) are intercepted and Part 1 of the flag is retrieved via developer tools or `curl`.
- **Initial Finding (Pre-Fix):** **FAIL (BUG-01)** — Entire flag was dumped into a single visible HTML comment on `index.html`.
- **Test Execution Steps:**
  1. Navigate to `http://<IP>:80/about.html` in browser.
  2. Attempt right-click inspect $\rightarrow$ JavaScript alert triggers; context menu is blocked.
  3. Attempt `Ctrl+U` $\rightarrow$ Keypress is intercepted.
  4. Execute `curl -s http://<IP>:80/about.html | grep -i "BPCTF"`
  5. Extract Part 1: `BPCTF{r3c0n_`
- **Expected Outcome:** Client-side shortcuts are intercepted. HTTP response yields Part 1: `BPCTF{r3c0n_`.
- **Unintended Shortcut Check:** Prevents zero-effort solve via simple right-click inspection.
- **Status:** **PASS (Defect BUG-01 Closed)**

---

### TC-02: Stage 1 — Image Metadata (EXIF) Clue & Flag Assembly
- **Target Stage & Focus:** Stage 1 (Open Eyes - Steganography)
- **Test Objective:** Verify that `novatech_logo.png` contains Part 2 of the flag in its metadata and assembles to `BPCTF{r3c0n_m4st3r}`.
- **Initial Finding (Pre-Fix):** **PASS** — EXIF metadata preserved across container build.
- **Test Execution Steps:**
  1. Download logo: `curl -s http://<IP>:80/novatech_logo.png -o logo.png`
  2. Inspect metadata: `exiftool logo.png | grep -i "Artist"`
  3. Observe metadata tag: `Artist: m4st3r}`
  4. Assemble Part 1 and Part 2: `BPCTF{r3c0n_m4st3r}`
- **Expected Outcome:** Metadata extraction cleanly yields `m4st3r}`. Assembled flag matches CTFd baseline.
- **Unintended Shortcut Check:** Ensures participants must perform actual forensic metadata analysis.
- **Status:** **PASS**

---

### TC-03: Stage 2 — Reverse Proxy API Path Fuzzing & Unauthenticated Disclosure
- **Target Stage & Focus:** Stage 2 (Knock Knock - Web Recon / API Security)
- **Test Objective:** Ensure `/api/` endpoint is discoverable via Gobuster over port 80 and exposes admin credentials and Flag 2.
- **Initial Finding (Pre-Fix):** **FAIL (BUG-02)** — API ran on an unmapped standalone port with no reverse proxy integration.
- **Test Execution Steps:**
  1. Run directory enumeration: `gobuster dir -u http://<IP>:80 -w /usr/share/wordlists/dirb/common.txt`
  2. Gobuster discovers: `/api/` (Status 301/200).
  3. Query endpoint: `curl -s http://<IP>:80/api/v1/users/`
  4. Inspect JSON payload for users, credentials, and Stage 2 flag.
- **Expected Outcome:** JSON response returns admin credentials (`admin : N0v4T3ch@dm1n`) and Stage 2 flag: `BPCTF{4p1_3xp0sur3_l34ks_cr3ds}`.
- **Unintended Shortcut Check:** Reverse proxy ensures uniform single-port (80) penetration testing.
- **Status:** **PASS (Defect BUG-02 Closed)**

---

### TC-04: Stage 3 — RBAC Cookie Manipulation & Privilege Escalation
- **Target Stage & Focus:** Stage 3 (The Login Wall - Access Control / OWASP A01)
- **Test Objective:** Confirm that authenticating with Stage 2 credentials issues a low-privilege `nova_role=guest` cookie, and altering it to `admin` unlocks Flag 3.
- **Initial Finding (Pre-Fix):** **FAIL (BUG-03)** — Submitting valid credentials directly dumped the flag without access control.
- **Test Execution Steps:**
  1. POST to `http://<IP>:80/novatech-portal/login.php` with `admin:N0v4T3ch@dm1n`.
  2. Verify Set-Cookie header: `nova_role=guest; path=/`.
  3. Request `dashboard.php` with `nova_role=guest` $\rightarrow$ Displays *"Access Denied: Standard User"*.
  4. Tamper cookie: `nova_role=admin`.
  5. Request `dashboard.php` with modified cookie.
- **Expected Outcome:** Dashboard unlocks elevated card: Flag 3 (`BPCTF{4uth_p0rt4l_4cc3ss}`).
- **Unintended Shortcut Check:** Prevents bypass of authorization testing.
- **Status:** **PASS (Defect BUG-03 Closed)**

---

### TC-05: Stage 4 — Web Root Isolation & Direct Download Prevention
- **Target Stage & Focus:** Stage 4 (Scrambled Secrets - Unintended Path Check)
- **Test Objective:** Verify that `config_backup.enc` cannot be directly fetched via HTTP GET request over `/files/`.
- **Initial Finding (Pre-Fix):** **FAIL (BUG-04)** — Backup was stored in `/var/www/html/backups/` and accessible via direct download.
- **Test Execution Steps:**
  1. `curl -I http://<IP>:80/files/backups/config_backup.enc`
  2. `curl -I http://<IP>:80/files/config_backup.enc`
  3. `curl -I http://<IP>:80/files/opt/backups/config_backup.enc`
- **Expected Outcome:** All requests return `HTTP 404 Not Found`. File is completely isolated outside web root.
- **Unintended Shortcut Check:** Forces participants to exploit the command injection vulnerability.
- **Status:** **PASS (Defect BUG-04 Closed)**

---

### TC-06: Stage 4 — Command Injection Execution & Cryptographic Decoding
- **Target Stage & Focus:** Stage 4 (Scrambled Secrets - Web Exploitation & Crypto)
- **Test Objective:** Verify command injection via ping input: `127.0.0.1; cat /opt/backups/config_backup.enc` and decode the recovered ciphertext.
- **Initial Finding (Pre-Fix):** **PASS** — Command injection parameter correctly accepts shell delimiters.
- **Test Execution Steps:**
  1. Access `http://<IP>:80/files/`
  2. Submit parameter: `?host=127.0.0.1; cat /opt/backups/config_backup.enc`
  3. Capture base64 ciphertext from HTML response.
  4. Base64 decode to reveal ROT13 ciphertext.
  5. Apply ROT13 rotation to reveal deploy SSH password and Flag 4.
- **Expected Outcome:** Recovers deploy user password (`D3pl0y#S3cur3!`) and Flag 4: `BPCTF{crypt0_l4y3rs_d3c0d3d}`.
- **Unintended Shortcut Check:** Restricted ping packet count (`ping -c 2`) prevents server socket starvation.
- **Status:** **PASS**

---

### TC-07: Stage 5 — Forensic Zip Extraction & Password Cracking Integrity
- **Target Stage & Focus:** Stage 5 (Dead Logs Tell Tales - Digital Forensics)
- **Test Objective:** Verify that `/tmp/suspicious.zip` requires John the Ripper cracking and cannot be bypassed via cleartext keys.
- **Initial Finding (Pre-Fix):** **FAIL (BUG-05)** — Debugging key `/home/deploy/.secret_key` allowed bypassing zip cracking.
- **Test Execution Steps:**
  1. SSH to target: `ssh deploy@<IP> -p 2222` with password `D3pl0y#S3cur3!`
  2. Check for cleartext keys: `ls -la /home/deploy/.secret_key` (Not found).
  3. Download `/tmp/suspicious.zip` to Kali attack box via `scp -P 2222`.
  4. Generate hash: `zip2john suspicious.zip > zip.hash`
  5. Crack hash: `john --wordlist=/usr/share/wordlists/rockyou.txt zip.hash`
  6. Unzip with cracked password (`shadow123`) and inspect `notes.txt`.
- **Expected Outcome:** Password cracked successfully. `notes.txt` reveals Flag 5 (`BPCTF{f0r3ns1cs_4rt3f4ct_r3c0v3r3d}`) and hints at SUID reader binary.
- **Unintended Shortcut Check:** Eliminated cleartext key bypass, enforcing legitimate forensic cryptanalysis.
- **Status:** **PASS (Defect BUG-05 Closed)**

---

### TC-08: LO3 End-to-End Cryptographic Kill-Chain Validation
- **Target Stage & Focus:** All Stages (Integration & Regression Testing)
- **Test Objective:** Validate SHA-256 integrity of all 6 flags and confirm automated grading engine rejects invalid flags.
- **Initial Finding (Pre-Fix):** **PASS** — Verified across regression suite.
- **Test Execution Steps:**
  1. Run validation engine: `python scripts/validate_killchain_e2e.py`
  2. Verify SHA-256 baseline matches for Stages 1 through 6.
  3. Execute anti-forgery check: Submit malformed flag `BPCTF{wrong_flag_test}`.
- **Expected Outcome:** All 6 flags match SHA-256 baseline signatures (100% integrity). Malformed flag rejected `[PASS]`. Total score: 1,550 points.
- **Unintended Shortcut Check:** Guarantees absolute score integrity and zero flag collisions.
- **Status:** **PASS**

---

## 5. Verification of Assignment 01 Checklist (16 Items)

Every item from Section 11.1 of the approved Assignment 01 specification was re-tested and verified:

| Item # | Verification Item | Execution Method | Result |
| :---: | :--- | :--- | :---: |
| **1** | All containers start cleanly | `docker compose up -d` on both machines | **PASS** |
| **2** | Nginx routing (Machine 1) | HTTP requests to `/`, `/api/`, `/novatech-portal/`, `/files/` | **PASS** |
| **3** | SSH access (S5/S6) | `ssh deploy@<IP> -p 2222` with Stage 4 credentials | **PASS** |
| **4** | CTFd loads all challenges | CTFd Admin panel check for all 6 challenges & points | **PASS** |
| **5** | S1 flag retrieval | HTML source inspection (`about.html`) + `exiftool` on logo | **PASS** |
| **6** | S2 API endpoint | Gobuster directory scan $\rightarrow$ `/api/v1/users/` | **PASS** |
| **7** | S3 portal login | Authenticate with credentials from Stage 2 | **PASS** |
| **8** | S3 invalid login rejection | Submit invalid credentials; verify error handling | **PASS** |
| **9** | S4 decode chain | Injected command on `/files/` $\rightarrow$ decode Base64 + ROT13 | **PASS** |
| **10** | S5 forensic chain | SSH login $\rightarrow$ crack `suspicious.zip` with John the Ripper | **PASS** |
| **11** | S6 SUID exploit | Enumerate SUID binaries $\rightarrow$ `/usr/local/bin/reader` $\rightarrow$ root shell | **PASS** |
| **12** | All flags validate in CTFd | SHA-256 validation via `validate_killchain_e2e.py` | **PASS** |
| **13** | Wrong flag rejection | Negative assertion testing with malformed flag | **PASS** |
| **14** | Inter-container isolation | Direct inter-container unauthorized access blocked | **PASS** |
| **15** | Machine isolation | Verified challenges cannot compromise host or Machine 2 | **PASS** |
| **16** | Container reset | Full `docker compose down` and restart verification | **PASS** |

---