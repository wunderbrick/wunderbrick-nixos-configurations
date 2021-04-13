############################################################################################################################

thinkpad-e585:
	nixos-rebuild -I nixos-config=./targets/thinkpad-e585/machine.nix switch

flake-thinkpad-e585:
	nixos-rebuild switch --flake .#thinkpad-e585

############################################################################################################################

thinkpad-x1:
	nixos-rebuild -I nixos-config=./targets/thinkpad-x1/machine.nix --target-host thinkpad-x1 switch

flake-thinkpad-x1:
	nixos-rebuild switch --flake .#thinkpad-x1 --target-host thinkpad-x1 --build-host localhost

############################################################################################################################

truenas-irc-client-vm:
	nixos-rebuild -I nixos-config=./targets/truenas-irc-client-vm/machine.nix --target-host truenas-irc-client-vm switch

flake-truenas-irc-client-vm:
	nixos-rebuild switch --flake .#truenas-irc-client-vm --target-host truenas-irc-client-vm --build-host localhost

############################################################################################################################

truenas-transmission-vm:
	nixos-rebuild -I nixos-config=./targets/truenas-transmission-vm/machine.nix --target-host truenas-transmission-vm switch

flake-truenas-transmission-vm:
	nixos-rebuild switch --flake .#truenas-transmission-vm --target-host truenas-transmission-vm --build-host localhost

############################################################################################################################

apu-router:
	nixos-rebuild -I nixos-config=./targets/apu-router/machine.nix --target-host apu-router switch

flake-apu-router:
	nixos-rebuild switch --flake .#apu-router --target-host apu-router --build-host localhost

############################################################################################################################

#thinkpad-t400:
#	nixos-rebuild -I nixos-config=./targets/thinkpad-t400/machine.nix --target-host thinkpad-t400 switch

# flake-thinkpad-t400:
#	nixos-rebuild switch --flake .#thinkpad-t400 --target-host thinkpad-t400 --build-host localhost