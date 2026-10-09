# save as generate_enc.py and run: python generate_enc.py
import base64, codecs, os

def vigenere_encrypt(text, key):
    result = []
    key_lower = key.lower()
    ki = 0
    for c in text:
        if c.isalpha():
            shift = ord(key_lower[ki % len(key_lower)]) - ord('a')
            base = ord('A') if c.isupper() else ord('a')
            result.append(chr((ord(c) - base + shift) % 26 + base))
            ki += 1
        else:
            result.append(c)
    return ''.join(result)

# Only sensitive content gets Vigenere encrypted
sensitive = (
    "SSH_HOST=localhost\n"
    "SSH_PORT=2222\n"
    "SSH_USER=deploy\n"
    "SSH_PASS=D3pl0y#S3cur3!\n"
    "FLAG=BPCTF{crypt0_l4y3rs_d3c0d3d}"
)

# Comment is placed OUTSIDE Vigenere so it's readable after ROT13 decode only
comment = "\n# Vigenere encoded - key: domain suffix from recon"

layer1 = vigenere_encrypt(sensitive, 'lk') + comment  # Vigenere only on sensitive
layer2 = codecs.encode(layer1, 'rot_13')               # ROT13 the whole thing
layer3 = base64.b64encode(layer2.encode()).decode()    # Base64 encode

os.makedirs("src/backups", exist_ok=True)
with open("src/backups/config_backup.enc", "w") as f:
    f.write(layer3)
print("Done! config_backup.enc regenerated.")