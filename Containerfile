FROM docker.io/debian:11  AS rengginang-box

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="Debian image for sigil dev" \
      maintainer="yukidream@mashirokuratamorfo@gmail.com"

# copy sigil lib
COPY sigil_lib /
# install package
RUN apt-get update && \ 
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install build-essentials cmake cmake-curses-gui libglew-dev libopenal-dev xterm codeblocks  

RUN rm -rf /tmp/* 
