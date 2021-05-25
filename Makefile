############################################################################################################################

thinkpad-e585:
	nixos-rebuild -I nixos-config=./targets/thinkpad-e585/machine.nix switch

flake-thinkpad-e585:
	nixos-rebuild switch --flake .#thinkpad-e585 --impure

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
	nixos-rebuild switch --flake .#truenas-transmission-vm --target-host truenas-transmission-vm --build-host localhost --impure

############################################################################################################################

apu-router:
	nixos-rebuild -I nixos-config=./targets/apu-router/machine.nix --target-host apu-router switch

flake-apu-router:
	nixos-rebuild switch --flake .#apu-router --target-host apu-router --build-host localhost --impure

############################################################################################################################

#thinkpad-t400:
#	nixos-rebuild -I nixos-config=./targets/thinkpad-t400/machine.nix --target-host thinkpad-t400 switch

# flake-thinkpad-t400:
#	nixos-rebuild switch --flake .#thinkpad-t400 --target-host thinkpad-t400 --build-host localhost

############################################################################################################################

rpi4-0:
	nixos-rebuild -I nixos-config=./targets/rpi4-0/machine.nix --target-host rpi4-0 switch

flake-rpi4-0:
	nixos-rebuild switch --flake .#rpi4-0 --target-host rpi4-0 --build-host localhost
