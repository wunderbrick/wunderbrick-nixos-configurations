# per the Wiki: https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{ config, pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0hs15hb7LrQoy/8G7w32OOBgO88xUChszdBmrPcQtIggjOr7E+x2zZbZhdNSO22cKrnrKfFleMhPtW5BFThYiEpVla92JDXgBN90Bm1YbTloUYY+DOjyOpirX73/K0gK8hieCC5PcDz6r9hI2GSLMkzWRCCnJnc7pU48JiSe12uzbqAk5+u9psUx9RLUL5G0Vnw/TrU5MQJnIQiN7zrnkvuS4opQIgz+7hp7HZT9gcH2WYlnUsHkN+uoeBMvGiSDRFivUAEIknlIsenW5zHVekrSC3TzsoUb2Pwjhr4Fydy+Pga06M/Nq4UzKMdR1mLdZEGMN63ZOpNeWWekwQ539VNS80Y3cUxSByCFQSWu+FcG2bCu8zdHnrB3Zh/SDbiT651icLvrUpQVEnU3yq3wowlq4Fl/na5BGsNvMKXn00mr5hCLRkIG1zsoP86DhTI9Huiu4xXtfQCVI3VT/b/ax0mYk5kQdBI/3lz0t98REqwQ1ab0YV4x5eMf0XqcSTlrblTK6sZgJwfTkp0Pm1tKqB2+QAD7VS/8Uygz3xPyx+12f+meX4U+FRlIjjcAIbZ6fO23u1skluB7ba7mnxK9sziDDYOfodof4+HJzaVG/NKAOlwuA5YFPPDh0GZERRWB+HIgmZXenEcPRUNeg8kaqBt6+vIy+ljTkMDc/dPjQvQ== awp@nixos-e585"
  ];
}
