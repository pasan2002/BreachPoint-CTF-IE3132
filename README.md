# BreachPoint CTF — Multi-Stage Penetration Testing Environment

[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue?logo=docker)](https://www.docker.com/)
[![Architecture](https://img.shields.io/badge/Architecture-Dual--Host%20Containerized-orange)]()
[![Platform](https://img.shields.io/badge/Platform-CTF%20%2F%20Penetration%20Testing-green)]()
[![Status](https://img.shields.io/badge/Status-Deployed%20%26%20Verified-brightgreen)]()

**BreachPoint CTF** is a custom, multi-stage vulnerable infrastructure and Capture The Flag (CTF) platform designed for hands-on cybersecurity training and penetration testing assessment. Built on a modular **Dual-Host Containerized Architecture**, it physically segregates the challenge execution nodes from the scoring and control plane to mirror enterprise CTF platforms like HackTheBox.

---

## 📐 Platform Architecture Overview

The system is deployed across two physically isolated or logically separated hosts connected only via the participant network:

```
                  +-------------------------------------------------------+
                  |                 Participant Machine                   |
                  +-------------------------------------------------------+
                                    |                   |
                     HTTP / Port 80 |                   | HTTP / Port 8000 (CTFd)
                                    v                   v
+---------------------------------------+   +---------------------------------------+
|              MACHINE 1                |   |              MACHINE 2                |
|       (Challenge Infrastructure)      |   |    (Scoring & Platform Control)       |
|                                       |   |                                       |
|  +---------------------------------+  |   |  +---------------------------------+  |
|  |       Nginx Reverse Proxy       |  |   |  |       Nginx Reverse Proxy       |  |
|  +---------------------------------+  |   |  +---------------------------------+  |
|                  |                    |   |                  |                    |
|    +-------------+-------------+      |   |                  v                    |
|    |             |             |      |   |  +---------------------------------+  |
|    v             v             v      |   |  |         CTFd Platform           |  |
| [s1-web]    [s2-api]     [s3-portal]  |   |  +---------------------------------+  |
|                            |          |   |                  |                    |
|                            v          |   |                  v                    |
|                         [s3-db]       |   |  +---------------------------------+  |
|                            |          |   |  |         MariaDB / Redis         |  |
|                            v          |   |  +---------------------------------+  |
|                         [s4-files]    |   +---------------------------------------+
|                            |          |
|    SSH / 2222              v          |
|  ----------->          [s5s6-ssh]     |
+---------------------------------------+
```

---

## 🎯 Challenge Matrix (Machine 1)

Machine 1 hosts 6 interconnected challenge stages simulating a real-world enterprise compromise chain:

| Stage | Challenge Name | Container Name | Tech Stack | Primary Vulnerability Class | Flag Location |
| :---: | :--- | :--- | :--- | :--- | :--- |
| **S1** | Enterprise Recon | `s1-web` | Nginx / Static HTML5 | Information Disclosure & Web Reconnaissance | Hidden HTML comments / Assets |
| **S2** | KnockKnock API | `s2-api` | PHP 8.1 REST API | API Endpoint Enumeration & Parameter Manipulation | JSON Response |
| **S3** | The Login Wall | `s3-portal` | Apache2 / PHP 8.1 / MySQL 8.0 | Authentication Bypass & SQL Injection | Database / Session Store |
| **S4** | Scrambled Secrets | `s4-files` | Apache2 / PHP 8.1 | Remote Command Injection (`/files/`) | Web Root / System Files |
| **S5** | Shell Access | `s5s6-ssh` | Ubuntu 22.04 / OpenSSH | SSH Credentials & Low-Privilege Access | User Home Directory |
| **S6** | SUID Privilege Escalation | `s5s6-ssh` | C Wrapper / `less` SUID | Misconfigured SUID Binary & GTFOBins Escape | `/root/flag.txt` |

---

## 🔒 Security Hardening & Container Isolation

To maintain CTF integrity and protect host infrastructure:

1. **Host Port Binding Minimization:**
   - Only Port `80` (`nginx-proxy`) and Port `2222` (`s5s6-ssh`) are published on the host.
   - Challenge boxes (`s1-web`, `s2-api`, `s3-portal`, `s3-db`, `s4-files`) have no exposed host ports, eliminating Nginx proxy bypass attempts.

2. **Network Egress Controls:**
   - Challenge containers reside on an isolated internal network (`internal: true`).
   - Outbound internet connections are blocked to prevent out-of-band data exfiltration and external reverse shells.

3. **Fine-Grained Linux Capabilities:**
   - Stage 6 (`s5s6-ssh`) grants `CAP_SETUID` and `CAP_SETGID` for the C wrapper SUID privilege escalation (`/usr/local/bin/reader`).
   - Critical host capabilities (e.g. `CAP_SYS_ADMIN`) and host socket mounts are omitted to prevent container breakout to the host system.

---

## 🚀 Quick Start & Deployment Guide

### Prerequisites
- [Docker Engine](https://docs.docker.com/engine/install/) v20.10+
- [Docker Compose](https://docs.docker.com/compose/install/) v2.0+

### Step 1: Clone Repository
```bash
git clone https://github.com/your-repo/BreachPoint_CTF.git
cd BreachPoint_CTF/machine1-challenges
```

### Step 2: Local Host Resolution (`/etc/hosts` or `C:\Windows\System32\drivers\etc\hosts`)
Add the following entries to resolve challenge subdomains:
```text
127.0.0.1   breachpoint.local
127.0.0.1   s1.breachpoint.local
127.0.0.1   s2.breachpoint.local
127.0.0.1   s3.breachpoint.local
127.0.0.1   s4.breachpoint.local
```

### Step 3: Launch Challenge Infrastructure (Machine 1)
```bash
docker compose up -d --build
```

### Step 4: Verify Deployment Status
```bash
docker compose ps
```
*Verify that `nginx-proxy` (Port 80) and `s5s6-ssh` (Port 2222) are running and healthy.*

---

## 🧪 Verification & Audit Commands

Run the built-in security audit steps to verify container isolation and network security:

```bash
# 1. Verify no exposed database ports
docker port s3-db

# 2. Verify network egress isolation (Should return "Network is unreachable")
docker exec s4-files ping -c 2 8.8.8.8

# 3. Verify Stage 6 Capabilities
docker inspect --format='CapAdd: {{.HostConfig.CapAdd}} | SecurityOpt: {{.HostConfig.SecurityOpt}}' s5s6-ssh
```

---

## 📁 Repository Structure

```text
BreachPoint_CTF/
├── machine1-challenges/
│   ├── docker-compose.yml          # Master orchestration file
│   ├── nginx-proxy/                # Reverse proxy config & routing rules
│   ├── s1-web/                     # Stage 1 HTML/CSS assets
│   ├── s2-api/                     # Stage 2 PHP API endpoints
│   ├── s3-portal/                  # Stage 3 Web Application
│   ├── s3-db/                      # Stage 3 MySQL setup scripts
│   ├── s4-files/                   # Stage 4 Vulnerable File Manager
│   └── s5s6-ssh/                   # Stage 5 & 6 SSH environment & SUID binary
└── README.md                       # Documentation
```

---

## ⚠️ Academic Disclaimer

This project is developed solely for educational purposes as part of the Penetration Testing module assessment. The vulnerabilities showcased herein are intentionally introduced for learning and evaluation within an isolated lab environment. Unauthorized testing against external systems is strictly illegal.
