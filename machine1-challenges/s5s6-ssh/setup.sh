#!/bin/bash
set -e

# Create deploy user
useradd -m -s /bin/bash deploy
echo "deploy:D3pl0y#S3cur3!" | chpasswd

# Write hidden .secret_key file
#echo -n "NT_S3cr3t_2026" > /home/deploy/.secret_key
#chown deploy:deploy /home/deploy/.secret_key
#chmod 600 /home/deploy/.secret_key

# Create suspicious.zip in /tmp protected with the password
cp /setup/notes.txt /tmp/notes.txt
cd /tmp
zip -P "shadow123" suspicious.zip notes.txt
rm notes.txt
chmod 644 /tmp/suspicious.zip

# Write pre-seeded .bash_history
cat > /home/deploy/.bash_history << 'EOF'
cd /tmp
ls -la
zip -e $SECRET suspicious.zip notes.txt
rm notes.txt
ls -la /tmp
exit
EOF

chown deploy:deploy /home/deploy/.bash_history
chmod 444 /home/deploy/.bash_history

# Compile custom vulnerable SUID binary
cat > /tmp/reader.c << 'CSRC'
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: reader <filename>\n");
        return 1;
    }
    setuid(0);
    setgid(0);
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "less \"%s\"", argv[1]);
    return system(cmd);
}
CSRC

gcc -o /usr/local/bin/reader /tmp/reader.c
chown root:root /usr/local/bin/reader
chmod u+s /usr/local/bin/reader
rm /tmp/reader.c

# Write root flag
cat > /root/flag.txt << 'EOF'

 ██████╗  ██████╗  ██████╗ ████████╗
 ██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝
 ██████╔╝██║   ██║██║   ██║   ██║
 ██╔══██╗██║   ██║██║   ██║   ██║
 ██║  ██║╚██████╔╝╚██████╔╝   ██║
 ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝

BPCTF{r00t_pr1v3sc_m1ss10n_c0mpl3t3}

Congratulations! You have completed the BreachPoint CTF.
You have successfully retraced the full NovaTech Corp breach kill chain.
EOF

chmod 600 /root/flag.txt
chown root:root /root/flag.txt