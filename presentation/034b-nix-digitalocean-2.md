
# Nix - DigitalOCean Image (2)

```nix
## nix/digitalocean/image.nix
{ pkgs, extraPackages ? [ ], ... }:
{
  imports = [ "${pkgs.path}/nixos/modules/virtualisation/digital-ocean-image.nix" ];
  system.stateVersion = "22.11";
  environment.systemPackages = with pkgs; [
    jq
  ] ++ extraPackages;
  
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
  };
}
```

