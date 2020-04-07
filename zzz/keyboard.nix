{ ... }:

{
  boot.kernelModules = [ "uinput" ];
  
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';
  
}
