#!/bin/bash/

USERNAME="user"
PASSWORD="pass"
IP_HOST_FILE="ip_list"
BACKUP_DIR="/tmp/"
EMAIL="mail@gmail.com"

while IFS=":" read -r ip hostname;do

DATE_DIR=$(date -d '2 days ago' '+%Y%m%d')
REMOTE_DIR="/backup/$hostname/@DATE_DIR"

echo "Connecting  to $ip ($hostname) to copy files from $REMOTE_DIR."

sshpass -p "$PASSWORD" ssh -r -o StrictHostKeyChecking=no "${USERNAME}@$ip:REMOTE_DIR*" "BACKUP_DIR/"
if [$? -eq 0]; then
echo "Backup from $ip ($hostname) completed successfully."
else
echo "Backup from $ip ($hostname) failed."
fi
done< "$IP_HOST_FILE"

backup_file="backup_$(date +%Y%m%d).tar.gz"
tar -czf "$backup_file" -C "$BACKUP_DIR" .
if [$? -eq 0]; then
echo "Compression  of the backup files completed successfully."
else
echo "Compression of the backup files failed."
fi

echo "Backup completed for all IPs." | mail -s "Backup Report." -a "$backup_file" "$EMAIL"
if [$? -eq 0]; then
echo "Email sent successfully."
else
echo "Email not sent."
fi
