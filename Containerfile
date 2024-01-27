FROM rockylinux:9

ARG STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

ENV PATH=/steam/linux32:/steam/linux64:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
ENV LD_LIBRARY_PATH=/steam/linux32:/steam/linux64
ENV STEAMEXE=/steam/linux32/steamcmd

RUN dnf update -y; \
    dnf install -y \
      sudo \
      glibc.i686 \
      libstdc++.i686 \
      libcurl.i686 \
      python3 \
      python3-pyyaml \
      xdg-user-dirs \
    ; \
    useradd -d /steam steam; \
    install -o steam -g steam -d /palworld; \
    curl -sL "$STEAMCMD_URL" | tar -C /steam -xzvf -; \
    chown -R steam:steam /steam; \
    chmod +x /steam/linux32/steamcmd;

WORKDIR /palworld

COPY update.script /palworld/update.script

RUN runuser -u steam steamcmd +quit; \
    runuser -u steam steamcmd +quit; \
    runuser -u steam steamcmd +runscript /palworld/update.script; \
    [[ -e "/palworld/Pal/Saved" ]] && mv /palworld/Pal/Saved /palworld/Pal/Saved.init; \
    install -o steam -g steam -d /data; \
    ln -s /data /palworld/Pal/Saved;

COPY palworld-helper /palworld/palworld-helper
COPY entrypoint.sh /entrypoint.sh

EXPOSE 8211/udp

VOLUME /config
VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]
