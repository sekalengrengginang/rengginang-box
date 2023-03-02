FROM docker.io/archlinux/archlinux:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="ArchLinux image with my personal package selection" \
      maintainer="yukidream"

# Pacman Initialization
RUN sed -i 's/#Color/Color/g' /etc/pacman.conf && \
    printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" | tee -a /etc/pacman.conf && \
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf && \
    pacman -Syu --noconfirm 

# install git and base-devel
RUN pacman -S --noconfirm base-devel git

# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add paru and install some packages
USER build
WORKDIR /home/build

RUN git config --global protocol.file.allow always && \
    git clone https://aur.archlinux.org/paru-bin.git --single-branch && \
    cd paru-bin && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -drf paru-bin 

COPY extra-packages /
RUN paru -S --noconfirm - < extra-packages
RUN rm /extra-packages

USER root
WORKDIR /

# symlink for accesing flatpak,podman,rpm-ostree from inside container
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree 

# Cleanup
RUN pacman -Scc --noconfirm

RUN userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf /tmp/* &&

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox
