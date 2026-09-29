# Docker for local containers. Optional per host.
{ ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    # Keep Docker networks away from the 10.x lab ranges and Pangolin's 172.20.0.0/16.
    daemon.settings.default-address-pools = [
      {
        base = "172.30.0.0/16";
        size = 24;
      }
    ];
  };
}
