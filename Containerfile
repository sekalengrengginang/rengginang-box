FROM docker.io/archlinux/archlinux:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="ArchLinux image with a bling" \
      maintainer="yukidream"

RUN   pacman -Syu --no-confirm htop neofetch

RUN   ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && 

     
