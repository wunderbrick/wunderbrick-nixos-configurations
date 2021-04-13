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
Host truenas-irc-client-vm 192.168.10.220
Hostname 192.168.10.220
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/nixos_irc_client/id_rsa

### truenas-transmission-vm ###
Host truenas-transmission-vm 192.168.10.207
Hostname 192.168.10.207
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/nixos_transmission/id_rsa

### apu-router ###
Host apu-router 192.168.10.125
Hostname 192.168.10.125
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/nixos_router/id_rsa

### thinkpad-x1 ###
Host thinkpad-x1 192.168.10.157
Hostname 192.168.10.157
PreferredAuthentications publickey
IdentityFile /home/awp/.ssh_lan/nixos_media_player/id_rsa
''