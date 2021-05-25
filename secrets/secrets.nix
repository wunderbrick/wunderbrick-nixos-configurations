let
  pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUt5hpwulXU0jTJR1SIENlVfZJcxUBj0iy9kSVaTlRl";
in
{
  "protonvpn-username.age".publicKeys = [ pubkey ];
  "protonvpn-password.age".publicKeys = [ pubkey ];
}