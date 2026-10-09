# BreachPoint CTF — Multi-Stage Penetration Testing Play Box

**Module:** IE3132 - Penetration Testing (Year 3, Semester 1)  
**Academic Year:** 2026  
**Institution:** Sri Lanka Institute of Information Technology (SLIIT) — Faculty of Computing  
**Group:** Group 05  
**Submission Package:** `IT24100239_IT24100172_IT24100258_IT24100975`  
**Platform Architecture:** Dual-Host Containerized Infrastructure (Docker Compose)  

---

## 👥 Group Members & Individual Responsibilities

As defined and approved in Assignment 01, each member owns an independent component evaluated individually out of 100 marks:

| Member ID | Student Name | Role | Assigned Stages / Components | Self-Developed Script (LO3) |
|:---:|:---|:---|:---|:---|
| **IT24100239** | Disanayaka D.M.C.N | **Member 1: Platform & Architecture** | Machine 1 & 2 Docker Compose, Nginx Reverse Proxy routing, container hardening, network isolation | [`scripts/audit_platform.py`](scripts/audit_platform.py) |
| **IT24100172** | Abeysekara T.T | **Member 2: Challenge Design A** | Stage 1 (OSINT), Stage 2 (API Security), Stage 3 (Web Authentication & Access Control) | [`scripts/solve_stages_1_to_3.py`](scripts/solve_stages_1_to_3.py) |
| **IT24100258** | Hewavitharana H.U.P | **Member 3: Challenge Design B** | Stage 4 (Command Injection & Crypto), Stage 5 (Forensics), Stage 6 (SUID Privilege Escalation) | [`scripts/exploit_stage4_crypto.py`](scripts/exploit_stage4_crypto.py)<br>[`scripts/solve_stages_5_and_6.py`](scripts/solve_stages_5_and_6.py) |
| **IT24100975** | Haggalla H.H.D.S | **Member 4: Integration, Testing & Docs** | CTFd scoring platform, UI customization, end-to-end QA validation, defect triage & design patches | [`scripts/validate_killchain_e2e.py`](scripts/validate_killchain_e2e.py) |

---

## 📐 Platform Architecture Overview

The BreachPoint CTF play box models a real-world enterprise compromise chain across a **Dual-Host Containerized Architecture**, separating challenge targets from the platform scoring engine:

```text
                  +-------------------------------------------------------+
                  |               Participant Attacker Host               |
                  +-------------------------------------------------------+
                                    |                   |
                     HTTP / Port 80 |                   | HTTP / Port 8000 (CTFd)
                                    v                   v
+---------------------------------------+   +---------------------------------------+
|              MACHINE 1                |   |              MACHINE 2                |
|       (Challenge Infrastructure)      |   |    (Scoring & Platform Control)       |
|                                       |   |                                       |
|  +---------------------------------+  |   |  +---------------------------------+  |
|  |     Nginx Reverse Proxy (:80)   |  |   |  |     Nginx Control Proxy (:8000) |  |
|  +---------------------------------+  |   |  +---------------------------------+  |
|                  |                    |   |                  |                    |
|    +-------------+-------------+      |   |                  v                    |
|    |             |             |      |   |  +---------------------------------+  |
|    v             v             v      |   |  |       CTFd Scoring Engine       |  |
| [s1-web]    [s2-api]     [s3-portal]  |   |  +---------------------------------+  |
|                            |          |   |                  |                    |
|                            v          |   |                  v                    |
|                         [s3-db]       |   |  +---------------------------------+  |
|                            |          |   |  |       MariaDB 10.11 Database    |  |
|                            v          |   |  +---------------------------------+  |
|                         [s4-files]    |   +---------------------------------------+
|                            |          |
|    SSH / 2222              v          |
|  ----------->          [s5s6-ssh]     |
+---------------------------------------+
```

---

## 🎯 Challenge Matrix & Difficulty Progression

All 6 stages strictly satisfy the Assignment 02 progression requirements across 6 distinct cybersecurity domains:

| Stage | Challenge Name | Domain | Difficulty | Points | Vulnerability / Technique | Primary Tools Enforced | Flag String |
|:---:|:---|:---|:---:|:---:|:---|:---|:---|
| **S1** | **Open Eyes** | OSINT & Passive Recon | Easy | 100 | HTML source disclosure & PNG metadata chunk leakage | Browser DevTools (`F12`), `curl`, ExifTool | `BPCTF{r3c0n_m4st3r}` |
| **S2** | **Knock Knock** | Web API Security | Easy | 150 | OWASP API3: Unauthenticated endpoint `/api/v1/users` leaking admin credentials | `gobuster`, `curl`, Burp Suite | `BPCTF{4p1_3xp0sur3_l34ks_cr3ds}` |
| **S3** | **The Login Wall** | Web Authentication | Moderate | 200 | Credential reuse + OWASP A01: Broken Access Control via cookie tampering (`nova_role=guest` ➔ `admin`) | Burp Suite Repeater, Cookie Inspector | `BPCTF{4uth_p0rt4l_4cc3ss}` |
| **S4** | **Scrambled Secrets** | Web Exploitation & Cryptography | Moderate | 250 | CWE-78: OS Command Injection in diagnostics tool + 3-layer cipher (**Base64 ➔ ROT13 ➔ Vigenère key `lk`**) | Command Injection, `curl`, CyberChef | `BPCTF{crypt0_l4y3rs_d3c0d3d}` |
| **S5** | **Dead Logs Tell Tales** | Digital Forensics | Moderate–Hard | 350 | `.bash_history` analysis, remote SCP exfiltration, offline archive dictionary cracking | OpenSSH, `scp`, `zip2john`, John the Ripper (`rockyou.txt`) | `BPCTF{f0r3ns1cs_4rt3f4ct_r3c0v3r3d}` |
| **S6** | **Root of Evil** | Linux Privilege Escalation | Hard (Capstone) | 500 | Custom SUID wrapper binary `/usr/local/bin/reader` with GTFOBins pager escape (`!/bin/bash`) | Linux commands, `find`, `strings`, GTFOBins | `BPCTF{r00t_pr1v3sc_m1ss10n_c0mpl3t3}` |
| **TOTAL** | **6 Stages** | **6 Domains** | — | **1,550** | Full Enterprise Compromise Kill Chain | — | — |

---

## 🔒 Security Hardening & Isolation Controls (Requirement 4)

1. **Host Ingress Minimization:**
   * **Machine 1:** Only Port `80` (HTTP Reverse Proxy) and Port `2222` (OpenSSH target container) are exposed to the host. Internal challenge services (`s1-web`, `s2-api`, `s3-portal`, `s4-files`) and the database (`s3-db` : 3306) have no exposed host ports.
   * **Machine 2:** Only Port `8000` (Nginx Control Proxy to CTFd) is published. MariaDB (:3306) is unexposed.
2. **Network Segmentation:**
   * Container communication is restricted to internal Docker bridge networks (`internal-net` and `ctfd_internal`).
   * Challenge containers operate with `internal: true` where appropriate to prevent unauthorized outbound connections.
3. **Container Escape Mitigations:**
   * Stage 6 SUID binary requires `CAP_SETUID` and `CAP_SETGID` inside the container. Dangerous host privileges (`CAP_SYS_ADMIN`, raw socket mounts, `/var/run/docker.sock`) are omitted to prevent container escape to the host VM.
4. **Independent Scoring Plane:**
   * Compromising Machine 1 up to the `root` user inside `s5s6-ssh` grants no access to Machine 2 or the CTFd database.

---

## 🚀 Deployment & Quick-Start Guide (Step-by-Step)

The CTF environment can be deployed from scratch on any Docker-capable system:

### Prerequisites
* [Docker Engine](https://docs.docker.com/engine/install/) v20.10+
* [Docker Compose](https://docs.docker.com/compose/install/) v2.0+
* Python 3.9+ (for running evaluation scripts)

---

### Step 1: Deploy Machine 1 (Challenge Infrastructure)
Open a terminal / PowerShell window:
```bash
cd machine1-challenges
docker compose up -d --build
```
*Verify containers are running:*
```bash
docker compose ps
```
Services running: `nginx-proxy` (:80), `s1-web`, `s2-api`, `s3-portal`, `s3-db`, `s4-files`, `s5s6-ssh` (:2222).

---

### Step 2: Deploy Machine 2 (CTFd Platform & Scoring)
In a separate terminal or the same host:
```bash
cd machine2-ctfd
docker compose up -d
```
*Verify CTFd is running:*
```bash
docker compose ps
```
The platform initializes automatically from the included database dump `ctfd-db/init.sql`.

---

### Step 3: Access Challenge & Platform Interfaces
* **Challenge Web Target (Machine 1):** `http://localhost/` (Port 80)
* **SSH Challenge Target (Machine 1):** `ssh deploy@localhost -p 2222` (Password: `D3pl0y#S3cur3!`)
* **CTFd Platform (Machine 2):** `http://localhost:8000/` (Port 8000)
  * **Admin Account:** `admin` | **Password:** `BreachPoint2026!`

---

## 🔄 Reset & Recovery Mechanism (Requirement 5)

To reset the CTF box back to its initial clean state at any time during testing:

### Reset Machine 1 (Challenges):
```bash
cd machine1-challenges
docker compose down -v
docker compose up -d --build
```
*Effect:* Purges all attacker artifacts in `/tmp`, restores original `~/.bash_history`, re-initializes MySQL database tables, and rebuilds pristine containers in under 45 seconds.

### Reset Machine 2 (CTFd Scoring):
```bash
cd machine2-ctfd
docker compose down
# To restore pristine database with challenges pre-loaded:
docker compose up -d
```

---

## 🛠️ Self-Developed Exploit & Solver Scripts (LO3 Compliance)

To satisfy Learning Outcome 3 and Requirement 6, each group member authored and verified a standalone Python automation script located in the [`scripts/`](scripts/) directory:

### 1. Member 1: Platform & Architecture Audit
* **Script:** [`scripts/audit_platform.py`](scripts/audit_platform.py)
* **Author:** Disanayaka D.M.C.N (`IT24100239`)
* **Execution:**
  ```bash
  python scripts/audit_platform.py
  ```
* **Function:** Automatically checks container health, port bindings, validates that MySQL (3306) is blocked from external access, verifies Nginx routing rules, and audits container Linux capabilities.

### 2. Member 2: Automated Solver for Stages 1 to 3
* **Script:** [`scripts/solve_stages_1_to_3.py`](scripts/solve_stages_1_to_3.py)
* **Author:** Abeysekara T.T (`IT24100172`)
* **Execution:**
  ```bash
  python scripts/solve_stages_1_to_3.py
  ```
* **Function:** Automates OSINT HTML comment and PNG metadata parsing (S1), unauthenticated API endpoint credential extraction (S2), and simulates web authentication + cookie tampering (`nova_role=admin`) to reveal the Stage 3 flag.

### 3. Member 3: Exploit & Decryption Solvers for Stages 4 to 6
* **Script A:** [`scripts/exploit_stage4_crypto.py`](scripts/exploit_stage4_crypto.py)
* **Script B:** [`scripts/solve_stages_5_and_6.py`](scripts/solve_stages_5_and_6.py)
* **Author:** Hewavitharana H.U.P (`IT24100258`)
* **Execution:**
  ```bash
  python scripts/exploit_stage4_crypto.py
  python scripts/solve_stages_5_and_6.py
  ```
* **Function:** 
  * `exploit_stage4_crypto.py`: Injects command payload to exfiltrate `config_backup.enc` and programmatically reverses the 3 cryptographic layers (Base64 ➔ ROT13 ➔ Vigenère key `lk`).
  * `solve_stages_5_and_6.py`: Inspects remote shell history, performs an offline dictionary attack against `suspicious.zip` using candidate wordlists (`shadow123`), and executes the `/usr/local/bin/reader` SUID privilege escalation to capture `/root/flag.txt`.

### 4. Member 4: End-to-End Kill Chain & Flag Validation Engine
* **Script:** [`scripts/validate_killchain_e2e.py`](scripts/validate_killchain_e2e.py)
* **Author:** Haggalla H.H.D.S (`IT24100975`)
* **Execution:**
  ```bash
  python scripts/validate_killchain_e2e.py
  ```
* **Function:** Tests and validates all 6 flags against SHA-256 signatures, runs forgery rejection tests with malformed flags, and verifies point progression compliance.

---

## 📝 Design Changes & QA Defect Resolution (Member 4 Presentation)

During integration and calibration testing led by **Haggalla H.H.D.S (IT24100975)**, four key defects were identified in the Assignment 01 initial design and resolved to prevent trivial shortcuts (Requirement 7) and maintain difficulty calibration:

| Defect ID | Stage | Initial Assignment 01 Design | QA Defect Identified by Haggalla | Assignment 02 Updated Implementation | Justification |
|:---:|:---:|:---|:---|:---|:---|
| **BUG-01** | **Stage 1** | Plain HTML comment visible via browser right-click ➔ *View Source*. | **Trivial Shortcut:** Participants bypassed command-line reconnaissance and DevTools entirely. | Injected active JavaScript policy blocking right-click context menu and `Ctrl+U`. | Strictly enforces Browser DevTools (`F12`) or CLI `curl` (LO1). |
| **BUG-03** | **Stage 3** | Submitting Stage 2 credentials immediately rendered the flag and `/files/` link. | **Difficulty Insufficiency:** No active web vulnerability or exploitation required; failed "Moderate" standard. | Implemented **OWASP A01: Broken Access Control** via client-controlled cookie (`nova_role=guest` ➔ `admin`). | Forces cookie inspection and manipulation via Burp Suite / DevTools (LO2). |
| **BUG-04** | **Stage 4** | `config_backup.enc` was stored in `/var/www/html/backups/`. | **Unintended Direct Download:** Participants could browse directly to `/files/backups/config_backup.enc` and bypass Command Injection. | Relocated archive to `/opt/backups/` outside Apache web root in `Dockerfile`. | Mandates OS Command Injection (`cat /opt/backups/...`) to retrieve the ciphertext. |
| **BUG-05** | **Stage 5** | Password stored in plaintext file `/home/deploy/.secret_key`. | **Missing Tool Enforcement:** Local `cat` bypassed offline cracking; cracking inside container is unrealistic. | Deleted `.secret_key`, encrypted zip with `shadow123`, requiring remote `scp` exfiltration to Kali. | Enforces real-world data exfiltration and offline cracking with John the Ripper / `rockyou.txt` (LO2). |

*A complete deep-dive with code diffs, test logs, and spoken scripts is documented in [`DESIGN_CHANGES_AND_TESTING_REPORT.md`](DESIGN_CHANGES_AND_TESTING_REPORT.md).*

---

## 📁 Repository Directory Structure

```text
BreachPoint_CTF/
├── machine1-challenges/
│   ├── docker-compose.yml              # Challenge host orchestration
│   ├── nginx-proxy/                    # Ingress reverse proxy (:80)
│   ├── s1-web/                         # Stage 1: Static site & EXIF logo
│   ├── s2-api/                         # Stage 2: PHP API leaking admin credentials
│   ├── s3-portal/                      # Stage 3: PHP auth portal & MySQL init.sql
│   ├── s4-files/                       # Stage 4: Diagnostics utility & /opt/backups/
│   └── s5s6-ssh/                       # Stage 5 & 6: OpenSSH container & SUID binary
├── machine2-ctfd/
│   ├── docker-compose.yml              # Scoring host orchestration (:8000)
│   ├── ctfd-db/                        # MariaDB 10.11 pre-seeded dump (init.sql)
│   ├── ctfd/                           # CTFd configuration, seed.py & challenges.json
│   └── nginx-proxy/                    # Control reverse proxy
├── scripts/
│   ├── audit_platform.py               # Member 1: Platform & isolation audit script
│   ├── solve_stages_1_to_3.py          # Member 2: Stages 1–3 solver script
│   ├── exploit_stage4_crypto.py        # Member 3: Stage 4 command injection solver
│   ├── solve_stages_5_and_6.py         # Member 3: Stages 5–6 forensics & SUID solver
│   └── validate_killchain_e2e.py       # Member 4: Flag hash validation & kill chain engine
├── generate_enc.py                     # Script generating 3-layer encrypted backup
├── make_logo.py                        # Script embedding metadata chunk into logo
├── DESIGN_CHANGES_AND_TESTING_REPORT.md# QA testing logs, defect tracking & presentation guide
├── TEAM_ROLES_AND_VIVA_PLAN.md         # Individual contribution matrix & viva guide
└── README.md                           # Master project documentation
```

---

## 🎥 Video Demonstration Structure (Max 20 Minutes)

The demonstration video is structured into four distinct, unscripted technical segments recorded from the running environment:

1. **Segment 1 — Member 1: Disanayaka D.M.C.N (0:00 – 5:00)**  
   * Scratch deployment via Docker Compose.
   * Architecture vs. design comparison, network isolation, and port exposure.
   * CTFd platform availability and reset mechanism demonstration.
   * Execution of [`scripts/audit_platform.py`](scripts/audit_platform.py).
2. **Segment 2 — Member 2: Abeysekara T.T (5:00 – 10:00)**  
   * Building of Stages 1, 2, and 3 (code, configuration, flag placement).
   * Live solution along intended path: DevTools inspection, `curl`, `gobuster`, API leak, and cookie tampering (`nova_role=admin`).
   * Execution of [`scripts/solve_stages_1_to_3.py`](scripts/solve_stages_1_to_3.py).
3. **Segment 3 — Member 3: Hewavitharana H.U.P (10:00 – 15:00)**  
   * Building of Stages 4, 5, and 6 (diagnostics tool, OpenSSH setup, custom SUID C wrapper).
   * Live solution along intended path: Command injection exfiltration, CyberChef 3-layer decryption, `scp` exfiltration, offline John the Ripper cracking, and GTFOBins pager escape to root.
   * Execution of [`scripts/exploit_stage4_crypto.py`](scripts/exploit_stage4_crypto.py) and [`scripts/solve_stages_5_and_6.py`](scripts/solve_stages_5_and_6.py).
4. **Segment 4 — Member 4: Haggalla H.H.D.S (15:00 – 20:00)**  
   * End-to-end kill chain flow and flag progression across all 6 stages.
   * Testing evidence (TC-01 through TC-08) and defect resolutions (BUG-01, BUG-03, BUG-04, BUG-05).
   * Technical justification of design changes from Assignment 01.
   * Execution of [`scripts/validate_killchain_e2e.py`](scripts/validate_killchain_e2e.py).

---

## ⚖️ Academic Integrity & Tool Acknowledgment

* All vulnerability scenarios were created in isolated Docker containers for educational assessment within the IE3132 module.
* External tools utilized: Docker, Docker Compose, CTFd v3.8, Nginx, Apache2, MariaDB, OpenSSH, ExifTool, Gobuster, Burp Suite Community Edition, CyberChef (GCHQ), John the Ripper, and GTFOBins.
