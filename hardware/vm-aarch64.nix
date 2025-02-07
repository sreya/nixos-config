# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
      ../hosts/configuration.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This won't work on other systems... it's hardcoded to my current M2's UUIDs.
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/a59b0f1c-1f2f-41fd-ae34-447df2d18909";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/BE67-84B4";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "vm";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # Required for automatic screen resize!
  hardware.parallels.enable = true;
  # The DPI has to be bigger for the smaller screen!
  services.xserver.dpi = 200;

  nixpkgs.overlays = [
    (import ../overlays/chromium.nix)
    (import ../overlays/discord.nix)
    (import ../overlays/slack.nix)
  ];

  environment.systemPackages = with pkgs; [
    # Google Chrome isn't available on arm64
    chromium
    discord
    slack
  ];
  environment.variables.BROWSER = "chromium";
}
