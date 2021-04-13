# Can't use --pure. You need ALSA and pulseaudio for this to work.
with import <nixpkgs> { };

let inherit (pkgs) haskellPackages;
in with haskellPackages;
let
  #unstable = import <nixos-unstable> {};

  haskellPkgs = hd:
    with hd;
    [
      Euterpea
      #unstable.haskellPackages.HSoM # optional companion library for Haskell School of Music # broken as of 9 April 2020
    ];

  ghc = ghcWithPackages haskellPkgs;

  nixPkgs = [ echo ghc cabal-install timidity soundfont-fluid ];

  timidityCfg =
    "./timidity.cfg"; # not sure how to specify *.sf2 from command line
in mkShell {
  name = "music";
  buildInputs = nixPkgs;
  shellHook = ''
    ps -ef | grep timidity | grep -v grep | awk '{print $2}' | xargs kill
    echo "soundfont ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2" > ${timidityCfg}
    timidity -iA -Os -B2,8 -Os -c ${timidityCfg} &
  '';
}
