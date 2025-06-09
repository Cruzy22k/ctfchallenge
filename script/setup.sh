#! /bin/bash
#this is a draft of the full script. 
CUR_VER=1.22
echo "current version is"
echo $CUR_VER
useradd -m -s /bin/bash admin
echo "admin:admin123" | chpasswd
usermod -aG wheel admin
#This sections just sets up a functioning admin acc on the vm. (assuming you just set up root in the setup)

#gets sshd running
dnf install -y openssh-server
systemctl enable sshd
systemctl start sshd

# Now we add clipriv000 and cliadmin000
useradd -m -s /bin/bash ctfadmin000 
# -m for making a home fir, uses /bin/bash to set the shell to bash
echo "ctfadmin000:securepass123" | chpasswd
echo "added ctfadmin000"

useradd -m -s /bin/bash os_clipriv000
echo "os_clipriv000:os_clipriv000" | chpasswd
echo "added clipriv000"
##done##

# we use ACL permissions to allow ctfadmin to read root. (nessacary step)
setfacl -m u:ctfadmin000:rx /root
# -m is for modify, u is for the user, r for read, x for execute, (for 
# directory travel) /root is the dir that we are talking about to the compter.

#SETUP FOR OS_CLIPRIV

echo "echo 'c2VjdXJlcGFzczEyMw==' | base64 --decode" > /home/os_clipriv000/.bash_history
chown root:root /home/os_clipriv000/.bash_history
chmod 400 /home/os_clipriv000/.bash_history
setfacl -m u:os_clipriv000:r /home/os_clipriv000/.bash_history #readonly

# this restricts the clipriv000 account to just read and execute, BUT only # in their home dir.
# we are also gonna add a hint file explaining what base64 is, and how to access its manpage. # its owned by root for best practice

echo -e "Welcome player. This challenge teaches you hows to use base64, and how chain attack and escalation of permissions can lead to massively scaling attack vectors.\nHint: look around, snoop in the history... learn how base64 works... good luck!\nRead the Challenge Markdown for more info.\nHint: the attackable username starts with 'ctf'" > /home/os_clipriv000/note.txt
chmod 400 /home/os_clipriv000/note.txt
chown root:root /home/os_clipriv000/note.txt
setfacl -m u:os_clipriv000:r /home/os_clipriv000/note.txt
chown root:root /home/os_clipriv000
chmod 555 /home/os_clipriv000

# fake crap coz its cool
echo "did some sussy things, progressing to the next stage"
sleep 2
echo "proccessing..."
sleep 2
echo "calculating the angle of differentiation"
sleep 2
echo "learning sleep patterns"
sleep 1
echo "Done! infomation collected and sent to China in... "
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "SENT!"
### SETUP FOR CTFADMIN000
#this is a hint file for people when they get access to ctfadmin000
echo "I think there's something important in /root..." > /home/ctfadmin000/note.txt  # creates a note file
chown root:root /home/ctfadmin000/note.txt #makes the file owned by root
chmod 400 /home/ctfadmin000/note.txt # read-only
setfacl -m u:ctfadmin000:r /home/ctfadmin000/note.txt # lets the fake admin account read it
chmod 555 /home/ctfadmin000 # owner can read , owner can ex
chown root:root /home/ctfadmin000 # owner as root

# creates the flag file
echo "CTF{a195d2ed41c0da0dfa1d08e196bff242}" | base64 > /root/flag.txt
chown root:root /root/flag.txt # flag is owned by root
chmod 440 /root/flag.txt
# sets permissions to '4' read for owner only (root), 4 for group, 0 for others
setfacl -m u:ctfadmin000:r /root/flag.txt
# here is where the magic happens, the ':r' allows ctfadmin read access of this flag, while still keeping the environment secure

#chmod 500 /root

#rm -r /root/script.sh
#echo "removed the script file"

echo "Setup complete. Reboot if needed."
echo "Made with ❤️ by cruzy"