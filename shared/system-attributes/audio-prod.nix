# services.jack
{
  jack = { # jack stuff is for SuperCollider
    alsa = { enable = true; };
    jackd = {
      enable = false; # Enable when using SuperCollider
      extraOptions = [
        "-dalsa"
        "--device"
        "hw:1"
      ]; # running this with current config, musnix enabled, and PulseAudio disabled got sound working with SuperCollider: jackd -r -d alsa -d hw:1
    };
  };
}
