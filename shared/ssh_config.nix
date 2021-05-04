''
########
# PLAY #
########

### Github ###
Host github.com
Hostname github.com
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_github/id_rsa

### truenas-irc-client-vm ###
Host truenas-irc-client-vm 192.168.2.13
Hostname 192.168.2.13
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/nixos_irc_client/id_rsa

### truenas-transmission-vm ###
Host truenas-transmission-vm 192.168.2.12
Hostname 192.168.2.12
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/nixos_transmission/id_rsa

### apu-router ###
Host apu-router 192.168.1.1
Hostname 192.168.1.1
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/nixos_router/id_rsa

### thinkpad-x1 ###
Host thinkpad-x1 192.168.3.96
Hostname 192.168.3.96
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/nixos_media_player/id_rsa

### rpi4-0 ###
Host rpi4-0 192.168.3.11
Hostname rpi4-0
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/rpi4-0/id_rsa
''
