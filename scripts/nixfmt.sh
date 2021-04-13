#!/bin/sh
nixfmt ../shared/system-attributes/*.nix
nixfmt ../shared/packages/*/*.nix
nixfmt ../shared/nix-shells/*/*.nix
nixfmt ../targets/*/*.nix
