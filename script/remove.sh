#!/bin/bash
# This script removes all the junk from b4


# Delete users and their home dirs
userdel -r os_clipriv000
userdel -r ctfadmin000
userdel -r admin

# Remove the flag and note files if they still exist
rm -f /root/flag.txt
rm -f /home/os_clipriv000/note.txt
rm -f /home/os_clipriv000/.bash_history
rm -f /home/ctfadmin000/note.txt

# Remove ACLs just in case they're still applied
setfacl -x u:ctfadmin000 /root 2>/dev/null
setfacl -x u:ctfadmin000 /root/flag.txt 2>/dev/null
setfacl -x u:os_clipriv000 /home/os_clipriv000/.bash_history 2>/dev/null
setfacl -x u:os_clipriv000 /home/os_clipriv000/note.txt 2>/dev/null
setfacl -x u:ctfadmin000 /home/ctfadmin000/note.txt 2>/dev/null

# Optional: Remove any leftover home directories just in case
rm -rf /home/os_clipriv000 /home/ctfadmin000 /home/admin
sudo rebooy
echo "CTF environment cleaned. System is now reset."
