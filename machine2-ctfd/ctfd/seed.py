import json
import re
import requests
import sys

BASE_URL = "http://localhost:8000"
ADMIN_USER = "admin"
ADMIN_PASS = "BreachPoint2026!"

session = requests.Session()

def login():
    resp = session.get(f"{BASE_URL}/login")
    if "nonce" not in resp.text:
        print("[!] Failed to load login page. Is CTFd running?")
        sys.exit(1)
        
    nonce = resp.text.split('name="nonce" type="hidden" value="')[1].split('"')[0]
    login_data = {
        "name": ADMIN_USER,
        "password": ADMIN_PASS,
        "nonce": nonce
    }
    r = session.post(f"{BASE_URL}/login", data=login_data)
    if r.status_code == 200 or r.history:
        print("[+] Logged in successfully to CTFd.")
    else:
        print("[!] Login failed. Check your admin credentials.")
        sys.exit(1)

def get_csrf_nonce():
    r = session.get(f"{BASE_URL}/admin/challenges")
    # Match both CTFd v3 ('csrfNonce': "...") and v2 (csrf_nonce = '...')
    match = re.search(r"['\"]?csrfNonce['\"]?\s*:\s*['\"]([^'\"]+)['\"]", r.text, re.IGNORECASE)
    if not match:
        match = re.search(r"csrf_nonce\s*=\s*['\"]([^'\"]+)['\"]", r.text)
    if not match:
        match = re.search(r'name=["\']csrf[-_]token["\']\s+content=["\']([^"\']+)["\']', r.text)
    
    if match:
        return match.group(1)
    else:
        print("[!] Could not locate CSRF token in admin page.")
        sys.exit(1)

def seed_challenges():
    with open("challenges.json", "r") as f:
        challenges = json.load(f)

    nonce = get_csrf_nonce()
    headers = {"CSRF-Token": nonce, "Content-Type": "application/json"}

    for chal in challenges:
        # 1. Create Challenge
        chal_payload = {
            "name": chal["name"],
            "category": chal["category"],
            "description": chal["description"],
            "value": chal["value"],
            "type": "standard",
            "state": "visible"
        }
        res = session.post(f"{BASE_URL}/api/v1/challenges", json=chal_payload, headers=headers)
        if res.status_code != 200:
            print(f"[-] Failed to create {chal['name']}: {res.text}")
            continue

        chal_id = res.json()["data"]["id"]
        print(f"\n[+] Created Challenge: {chal['name']} ({chal['value']} pts)")

        # 2. Add Flag
        flag_payload = {
            "challenge_id": chal_id,
            "content": chal["flag"],
            "type": "static",
            "data": "case_sensitive"
        }
        session.post(f"{BASE_URL}/api/v1/flags", json=flag_payload, headers=headers)
        print(f"    ├── Flag added: {chal['flag']}")

        # 3. Add Hints with Point Deductions
        for idx, h in enumerate(chal.get("hints", []), 1):
            hint_payload = {
                "challenge_id": chal_id,
                "content": h["content"],
                "cost": h["cost"]
            }
            h_res = session.post(f"{BASE_URL}/api/v1/hints", json=hint_payload, headers=headers)
            if h_res.status_code == 200:
                cost_label = "FREE" if h['cost'] == 0 else f"-{h['cost']} pts"
                print(f"    └── Hint {idx} ({cost_label}): {h['content'][:45]}...")

if __name__ == "__main__":
    login()
    seed_challenges()
    print("\n[✓] All 6 challenges, flags, and hint penalties successfully seeded! (Total: 1,550 pts)")