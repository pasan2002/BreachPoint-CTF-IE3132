<div align="center">

<img src="https://res.cloudinary.com/dl9ectnzs/image/upload/v1791022194/Screenshot_2026-10-03_153943_rcj1dy.png" alt="SLIIT Logo" width="320"/>

# BreachPoint CTF — Multi-Stage Penetration Testing Play Box
### Realistic Enterprise Compromise Chain & Dual-Host CTF Environment

**Sri Lanka Institute of Information Technology (SLIIT)**  
**Faculty of Computing — Cyber Security Specialization**  
**Module:** IE3132 - Penetration Testing (Year 3, Semester 1 — 2026)  
**Group:** Group 05 | **Submission Package:** `IT24100239_IT24100172_IT24100258_IT24100975`

---

</div>

## 📌 Project Overview

**BreachPoint CTF** is a custom-engineered, multi-stage vulnerable playground and Capture The Flag (CTF) evaluation environment modeled after real-world advanced persistent threat (APT) kill chains. Designed around the fictional infrastructure of **NovaTech Corp**, the platform presents an end-to-end attack narrative: from unauthenticated external OSINT reconnaissance, through API credential leakage, administrative portal privilege escalation, and remote command injection, to post-exploitation forensics and Linux SUID root privilege escalation.

The platform is engineered on an isolated **Dual-Host Containerized Architecture** using Docker Compose. Challenge execution nodes are physically decoupled from the scoring and validation plane (CTFd), ensuring that even a total root-level compromise of the challenge host cannot compromise or disrupt the CTF scoring infrastructure.

---

## 👥 Team Members & Responsibilities

| Student ID | Member Name | Role | Responsibilities & Component Ownership | Key Artifacts & LO3 Script |
|:---:|:---|:---|:---|:---|
| **IT24100239** | Disanayaka D.M.C.N | **Platform & Architecture** | Dual-host Docker Compose orchestration, Nginx reverse proxy routing, internal network segmentation, container hardening, resource constraints. | `audit_platform.py`<br>`machine1-challenges/docker-compose.yml`<br>`machine2-ctfd/docker-compose.yml` |
| **IT24100172** | Abeysekara T.T | **Challenge Design A** | Design and implementation of Stages 1, 2, and 3: static web assets, unauthenticated REST API endpoint, role-based auth portal, and MySQL backend. | `make_logo.py`<br>`scripts/solve_stages_1_to_3.py`<br>`machine1-challenges/s1-web/`<br>`machine1-challenges/s2-api/`<br>`machine1-challenges/s3-portal/` |
| **IT24100258** | Hewavitharana H.U.P | **Challenge Design B** | Design and implementation of Stages 4, 5, and 6: diagnostic command injection utility, 3-layer cryptographic generator, OpenSSH container, and custom SUID binary. | `exploit_stage4_crypto.py`<br>`solve_stages_5_and_6.py`<br>`s4-files/`, `s5s6-ssh/` |
| **IT24100975** | Haggalla H.H.D.S | **Integration, Testing & Docs** | CTFd platform deployment, custom challenge board UI styling, end-to-end QA validation, defect discovery (BUG-01 to BUG-05), and design iteration patches. | `validate_killchain_e2e.py`<br>`DESIGN_CHANGES_AND_TESTING_REPORT.md`<br>`challenges.json`, `init.sql` |

---

## 📐 Dual-Host Platform Architecture

The platform architecture strictly segregates the **Challenge Environment (Machine 1)** from the **Scoring & Platform Control Plane (Machine 2)**, connected only across an isolated participant network:

<div align="center">

<img src="https://res.cloudinary.com/dl9ectnzs/image/upload/v1791542791/diagram.drawio_zq0rwu.png" alt="BreachPoint CTF Dual-Host Architecture Diagram" width="90%"/>

*Figure 1: Dual-Host Network Segmentation, Ingress Port Mappings, and Container Interaction Architecture.*

</div>

### Architecture Specifications:
* **Machine 1 — Challenge Infrastructure:**
  * Runs on dedicated Docker network `internal-net` (Subnet: `172.20.0.0/16`).
  * Only two ports are exposed to the host: Port `80` (HTTP Ingress via Nginx Reverse Proxy) and Port `2222` (OpenSSH target).
  * Direct access to internal application containers (`s1-web`, `s2-api`, `s3-portal`, `s4-files`) and database (`s3-db` : 3306) is blocked from external networks.
* **Machine 2 — Scoring & Control Plane:**
  * Runs on isolated Docker network `ctfd_internal` (Subnet: `172.21.0.0/16`).
  * Dedicated MariaDB 10.11 instance stores user accounts, submissions, and flag hashes.
  * Web interface is exposed exclusively on Port `8000` via Nginx reverse proxy.
  * Complete isolation ensures root compromise of Machine 1 has zero attack vector against Machine 2.

---

## 🎯 Challenge Matrix & Difficulty Progression

All 6 stages follow the approved difficulty curve (**Easy ➔ Easy ➔ Moderate ➔ Moderate ➔ Moderate–Hard ➔ Hard**), covering 6 distinct cybersecurity domains:

| Stage | Challenge Name | Domain | Difficulty | Points | Vulnerability / Attack Vector | Primary Tools Required | Flag String |
|:---:|:---|:---|:---:|:---:|:---|:---|:---|
| **S1** | **Open Eyes** | OSINT & Passive Recon | Easy | 100 | Source code comment leakage + PNG metadata chunk exposure (`tEXt:Artist`) | Browser DevTools (`F12`), `curl`, ExifTool | `BPCTF{r3c0n_m4st3r}` |
| **S2** | **Knock Knock** | Web API Security | Easy | 150 | OWASP API3: Broken Object Property Level Auth — unauthenticated `/api/v1/users` leaks admin credentials | `gobuster`, `curl`, Burp Suite | `BPCTF{4p1_3xp0sur3_l34ks_cr3ds}` |
| **S3** | **The Login Wall** | Web Authentication | Moderate | 200 | Credential reuse + OWASP A01: Broken Access Control via cookie tampering (`nova_role=guest` ➔ `admin`) | Burp Suite Repeater, DevTools Cookie Storage | `BPCTF{4uth_p0rt4l_4cc3ss}` |
| **S4** | **Scrambled Secrets** | Web Exploitation & Cryptography | Moderate | 250 | CWE-78: OS Command Injection in ping utility + 3-layer cipher (**Base64 ➔ ROT13 ➔ Vigenère key `lk`**) | Command Injection, `curl`, CyberChef | `BPCTF{crypt0_l4y3rs_d3c0d3d}` |
| **S5** | **Dead Logs Tell Tales** | Digital Forensics | Moderate–Hard | 350 | `.bash_history` inspection, SCP archive exfiltration, offline dictionary cracking with `rockyou.txt` | OpenSSH, `scp`, `zip2john`, John the Ripper | `BPCTF{f0r3ns1cs_4rt3f4ct_r3c0v3r3d}` |
| **S6** | **Root of Evil** | Linux Privilege Escalation | Hard (Capstone) | 500 | Custom SUID binary `/usr/local/bin/reader` calling `less` with root UID; GTFOBins pager escape | Linux CLI, `find`, `strings`, GTFOBins | `BPCTF{r00t_pr1v3sc_m1ss10n_c0mpl3t3}` |
| **TOTAL** | **6 Challenges** | **6 Domains** | — | **1,550** | **Complete Enterprise Attack Kill Chain** | — | — |

---

## ⚡ Deployment & Running Commands (Quick-Start)

The entire play box can be deployed from scratch on any system with Docker Engine and Docker Compose installed.

### 1. Prerequisites
* [Docker Engine](https://docs.docker.com/engine/install/) v20.10+
* [Docker Compose](https://docs.docker.com/compose/install/) v2.0+
* Python 3.9+ (for running solver and validation scripts)

---

### 2. Start Machine 1 (Challenge Infrastructure)
In your terminal / PowerShell:

```bash
# Navigate to Machine 1 directory
cd machine1-challenges

# Build and start all 7 challenge containers in background
docker compose up -d --build
```

**Verify Machine 1 Status:**
```bash
docker compose ps
```
*Expected running services:*
* `nginx-proxy` (Port `80` exposed)
* `s1-web` (Internal)
* `s2-api` (Internal)
* `s3-portal` (Internal)
* `s3-db` (Internal MySQL)
* `s4-files` (Internal)
* `s5s6-ssh` (Port `2222` exposed)

---

### 3. Start Machine 2 (CTFd Platform & Scoring Engine)
In a separate terminal or the same host:

```bash
# Navigate to Machine 2 directory
cd machine2-ctfd

# Start CTFd platform and MariaDB database
docker compose up -d
```

**Verify Machine 2 Status:**
```bash
docker compose ps
```
*Expected running services:*
* `nginx-control` (Port `8000` exposed)
* `ctfd` (Internal Python WSGI)
* `ctfd-db` (Internal MariaDB 10.11)

---

### 4. Access URLs & Service Endpoints

| Service | Target URL / Connection Command | Access Credentials |
|---|---|---|
| **NovaTech Corporate Website (Stage 1)** | `http://localhost/` (Port 80) | Unauthenticated |
| **API Endpoint (Stage 2)** | `http://localhost/api/v1/users` | Unauthenticated |
| **Admin Portal (Stage 3)** | `http://localhost/novatech-portal/` | Harvested from Stage 2: `admin` : `N0v4T3ch@dm1n` |
| **System Diagnostics Tool (Stage 4)** | `http://localhost/files/` | Unlocked after Stage 3 cookie tampering |
| **SSH Target Server (Stage 5 & 6)** | `ssh deploy@localhost -p 2222` | Harvested from Stage 4: `deploy` : `D3pl0y#S3cur3!` |
| **CTFd Scoring Platform** | `http://localhost:8000/` (Port 8000) | **Admin:** `admin` \| **Pass:** `BreachPoint2026!` |

---

### 5. Stop the Containers

```bash
# Stop Machine 1
cd machine1-challenges
docker compose down

# Stop Machine 2
cd machine2-ctfd
docker compose down
```

---

## 🔄 Reset & Disaster Recovery (Requirement 5)

A core requirement is the ability to restore the environment to its pristine initial state within seconds if an attacker breaks a container or corrupts files.

### Full Reset of Machine 1 (Challenges):
```bash
cd machine1-challenges

# Teardown containers and purge all temporary volumes
docker compose down -v

# Rebuild clean container images and restart
docker compose up -d --build
```
*What this restores:*
* Deletes all attacker-created files in `/tmp` and home directories.
* Re-seeds `~/.bash_history` and re-encrypts `suspicious.zip`.
* Drops and re-initializes `s3-db` MySQL tables from `init.sql`.
* Restores all web files and SUID file permissions in under 45 seconds.

### Full Reset of Machine 2 (CTFd Platform):
```bash
cd machine2-ctfd
docker compose down
# To perform a complete database wipe and re-initialize from init.sql:
Remove-Item -Recurse -Force "ctfd/mysql-data"   # PowerShell
# or: rm -rf ctfd/mysql-data                    # Linux/macOS
docker compose up -d
```

---

## 🛠️ Self-Developed Exploit & Solver Scripts (LO3 Compliance)

To satisfy Learning Outcome 3 and Requirement 6, each group member authored and validated original Python automation scripts in the [`scripts/`](scripts/) directory:

### 1. Platform & Security Isolation Audit Script
* **File:** [`scripts/audit_platform.py`](scripts/audit_platform.py)
* **Author:** Disanayaka D.M.C.N (`IT24100239`) — Member 1
* **Execution:**
  ```bash
  python scripts/audit_platform.py
  ```
* **Capabilities:** Checks container health, verifies host ingress port restrictions, confirms database port 3306 is shielded, tests Nginx routing endpoints, and verifies that `CAP_SYS_ADMIN` is dropped on the SUID container.

### 2. Stages 1–3 Automated Reconnaissance & Exploitation Chain
* **File:** [`scripts/solve_stages_1_to_3.py`](scripts/solve_stages_1_to_3.py)
* **Author:** Abeysekara T.T (`IT24100172`) — Member 2
* **Execution:**
  ```bash
  python scripts/solve_stages_1_to_3.py
  ```
* **Capabilities:** Automates HTML comment & PNG metadata extraction (S1), unauthenticated API harvesting (S2), and handles session login with cookie tampering (`nova_role=admin`) to reveal the Stage 3 flag.

### 3. Stage 4 Command Injection & 3-Layer Decryption Solver
* **File:** [`scripts/exploit_stage4_crypto.py`](scripts/exploit_stage4_crypto.py)
* **Author:** Hewavitharana H.U.P (`IT24100258`) — Member 3
* **Execution:**
  ```bash
  python scripts/exploit_stage4_crypto.py
  ```
* **Capabilities:** Sends OS command injection payload `127.0.0.1; cat /opt/backups/config_backup.enc`, exfiltrates ciphertext, and reverses all 3 encryption layers (Base64 ➔ ROT13 ➔ Vigenère key `lk`).

### 4. Stages 5 & 6 Forensics, Archive Cracking & Privilege Escalation Solver
* **File:** [`scripts/solve_stages_5_and_6.py`](scripts/solve_stages_5_and_6.py)
* **Author:** Hewavitharana H.U.P (`IT24100258`) — Member 3
* **Execution:**
  ```bash
  python scripts/solve_stages_5_and_6.py
  ```
* **Capabilities:** Inspects remote `.bash_history`, simulates SCP exfiltration, launches an offline dictionary attack cracking `suspicious.zip` (`shadow123`), extracts `notes.txt`, and leverages the `/usr/local/bin/reader` SUID binary to extract the root flag.

### 5. End-to-End Kill Chain & Flag Validation Engine
* **File:** [`scripts/validate_killchain_e2e.py`](scripts/validate_killchain_e2e.py)
* **Author:** Haggalla H.H.D.S (`IT24100975`) — Member 4
* **Execution:**
  ```bash
  python scripts/validate_killchain_e2e.py
  ```
* **Capabilities:** Standalone validation engine verifying all 6 flags against SHA-256 signatures, testing rejection of forged flags, and confirming score progression compliance.

---

## 🔒 Security Hardening & Isolation Controls (Requirement 4)

1. **Host Ingress Minimization:**
   Only ports 80 and 2222 are published on Machine 1, and port 8000 on Machine 2. All inter-container dependencies (databases, application containers) run on internal subnets with zero external host port binding.
2. **Network Egress Restrictions:**
   Challenge containers reside on isolated internal Docker networks (`internal: true`) preventing outbound traffic to institutional or public internet infrastructure.
3. **Container Escape Mitigations:**
   Stage 6 SUID execution is restricted to the container namespace using fine-grained Linux capabilities (`CAP_SETUID` and `CAP_SETGID`). High-risk host privileges (`CAP_SYS_ADMIN`, host root filesystem mounts, Docker socket sharing) are strictly omitted.

---

## 📝 Design Iterations & Defect Resolutions (Member 4 QA Report)

Following integration testing led by **Haggalla H.H.D.S (IT24100975)**, four key defects were identified in the initial Assignment 01 design and patched to eliminate unintended shortcuts (Requirement 7):

| Defect ID | Stage | Initial Assignment 01 Design | QA Defect Identified by Haggalla | Updated Implementation (Patch) | Technical Justification |
|:---:|:---:|:---|:---|:---|:---|
| **BUG-01** | **Stage 1** | Plain HTML comment visible via browser right-click ➔ *View Page Source*. | **Trivial Shortcut:** Participants bypassed command-line tools and DevTools entirely. | Injected JavaScript policy blocking right-click contextmenu and `Ctrl+U`. | Strictly enforces Browser DevTools (`F12`) or CLI `curl` (LO1). |
| **BUG-03** | **Stage 3** | Entering Stage 2 credentials immediately revealed the flag and diagnostic tool link. | **Difficulty Insufficiency:** Pass-through form with no active exploitation; failed "Moderate" standard. | Implemented **OWASP A01: Broken Access Control** via client-controlled cookie (`nova_role=guest` ➔ `admin`). | Enforces session cookie inspection and privilege escalation via Burp Suite (LO2). |
| **BUG-04** | **Stage 4** | `config_backup.enc` was stored in `/var/www/html/backups/`. | **Unintended Direct Download:** Participants could browse directly to `/files/backups/config_backup.enc` without command injection. | Relocated archive to `/opt/backups/` outside the Apache web root in `Dockerfile`. | Mandates OS Command Injection (`cat /opt/backups/...`) to retrieve ciphertext. |
| **BUG-05** | **Stage 5** | Password stored in plaintext file `/home/deploy/.secret_key`. | **Missing Tool Enforcement:** Local `cat` bypassed offline cracking; cracking inside container is unrealistic. | Deleted `.secret_key`, encrypted zip with `shadow123`, requiring remote `scp` exfiltration to Kali. | Enforces real-world data exfiltration and offline cracking with John the Ripper / `rockyou.txt` (LO2). |

*Full testing logs, test cases (TC-01 to TC-08), and code diffs are available in [`DESIGN_CHANGES_AND_TESTING_REPORT.md`](DESIGN_CHANGES_AND_TESTING_REPORT.md).*

---

## 📁 Repository Directory Structure

```text
BreachPoint_CTF/
├── machine1-challenges/
│   ├── docker-compose.yml              # Challenge orchestration file (Machine 1)
│   ├── nginx-proxy/                    # Nginx reverse proxy routing (:80)
│   ├── s1-web/                         # Stage 1: Static website & EXIF logo
│   ├── s2-api/                         # Stage 2: PHP API leaking admin credentials
│   ├── s3-portal/                      # Stage 3: PHP auth portal & MySQL init.sql
│   ├── s4-files/                       # Stage 4: Diagnostics utility & /opt/backups/
│   └── s5s6-ssh/                       # Stage 5 & 6: OpenSSH container & SUID binary
├── machine2-ctfd/
│   ├── docker-compose.yml              # Platform orchestration file (Machine 2)
│   ├── ctfd-db/                        # MariaDB 10.11 pre-seeded dump (init.sql)
│   ├── ctfd/                           # CTFd configuration, seed.py & challenges.json
│   └── nginx-proxy/                    # Control proxy routing (:8000)
├── scripts/
│   ├── audit_platform.py               # Member 1: Platform & isolation audit script
│   ├── solve_stages_1_to_3.py          # Member 2: Stages 1–3 solver script
│   ├── exploit_stage4_crypto.py        # Member 3: Stage 4 command injection solver
│   ├── solve_stages_5_and_6.py         # Member 3: Stages 5–6 forensics & SUID solver
│   └── validate_killchain_e2e.py       # Member 4: Flag hash validation & kill chain engine
├── generate_enc.py                     # Script generating 3-layer encrypted backup
├── make_logo.py                        # Script embedding metadata chunk into logo
├── DESIGN_CHANGES_AND_TESTING_REPORT.md# QA testing logs, defect tracking & diffs
├── TEAM_ROLES_AND_VIVA_PLAN.md         # Individual contribution matrix & viva guide
└── README.md                           # Master project documentation
```

---

## ⚖️ Academic Integrity & External Tool Acknowledgments

* All vulnerability scenarios and configurations were built in isolated Docker containers specifically for educational evaluation within the IE3132 module at SLIIT.
* **External Frameworks & Tools Acknowledged:** Docker, Docker Compose, CTFd v3.8, Nginx, Apache2, MariaDB, OpenSSH, ExifTool, Gobuster, Burp Suite Community Edition, CyberChef (GCHQ), John the Ripper, and GTFOBins.
