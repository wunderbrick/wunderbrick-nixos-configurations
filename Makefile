thinkpad-e585:
	nixos-rebuild -I nixos-config=./targets/thinkpad-e585/machine.nix switch

flake-thinkpad-e585:
	nixos-rebuild switch --flake .#thinkpad-e585

thinkpad-x1:
	nixos-rebuild -I nixos-config=./targets/thinkpad-x1/machine.nix --target-host thinkpad-x1 switch

truenas-irc-client-vm:
	nixos-rebuild -I nixos-config=./targets/truenas-irc-client-vm/machine.nix --target-host truenas-irc-client-vm switch

truenas-transmission-vm:
	nixos-rebuild -I nixos-config=./targets/truenas-transmission-vm/machine.nix --target-host truenas-transmission-vm switch

apu-router:
	nixos-rebuild -I nixos-config=./targets/apu-router/machine.nix --target-host apu-router switch

#thinkpad-t400:
#	nixos-rebuild -I nixos-config=./targets/thinkpad-t400/machine.nix --target-host thinkpad-t400 switch
