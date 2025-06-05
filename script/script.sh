#this is a draft of the full script. 
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

chmod 700 /home/os_clipriv000 
# this restricts the clipriv000 account to just read, write, execute, BUT only # in their home dir. it also stops other vm users from seeing stuff in there.
echo "echo 'c2VjdXJlcGFzczEyMw==' | base64 --decode" >> /home/os_clipriv000/.bash_history
# this adds the 'mistake' command left in the bash history)
chown os_clipriv000:os_clipriv000 /home/os_clipriv000/.bash_history
chmod 600 /home/os_clipriv000/.bash_history
# we are also gonna add a hint file explaining what base64 is, and how to access its manpage. # its owned by root for best practice
echo "Welcome player. This challenge teaches you how to use base64, and how chain attack and escalation of permissions can lead to massively scaling attack vectors. Hint: look around, snoop in the history... learn how base64 works... good luck!" > /home/os_clipriv000/note.txt
chown root:root /home/os_clipriv000/note.txt
chmod 400 /home/os_clipriv000/note.txt
setfacl -m u:os_clipriv000:r /home/os_clipriv000/note.txt

# these commands are for realisicness, first one sets the owner to clipriv000, # and the second one makes it so that only the owner can read/write.
echo "CTF{a195d2ed41c0da0dfa1d08e196bff242}" | base64 > /root/flag.txt
chmod 640 /root/flag.txt 
# sets permissions to '6' rw for owner, '4' r for group, '0' nothing for others
chown root:root /root/flag.txt
# makes root own this file coz we aint stupid we don wan some random deleting  # it or changing it.
setfacl -m u:ctfadmin000:r /root/flag.txt
#this is a hint file for people when they get access to ctfadmin000
echo "I think there's something important in /root..." > /home/ctfadmin000/note.txt
chown root:root /home/ctfadmin000/note.txt
chmod 400 /home/ctfadmin000/note.txt
setfacl -m u:ctfadmin000:r /home/ctfadmin000/note.txt

rm -r /root/script.sh
echo "removed the script file"
# here is where the magic happens, the ':r' allows ctfadmin read access of this # flag, why still keeping the enviroment secure
echo "Setup complete. Reboot if needed."
