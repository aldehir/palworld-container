FROM rockylinux:9

ARG STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

ENV STEAMROOT=/steam
ENV STEAMEXE=$STEAMROOT/Steam/linux32/steamcmd

ENV LD_LIBRARY_PATH=$STEAMROOT/linux32:$STEAMROOT/linux64

RUN dnf update -y; \
    dnf install -y \
      sudo \
      glibc.i686 \
      libstdc++.i686 \
      libcurl.i686 \
    ; \
    useradd -d "${STEAMROOT}" steam; \
    install -o steam -g steam -d /palworld; \
    curl -sL "$STEAMCMD_URL" | tar -C "${STEAMROOT}" -xzvf -; \
    chown -R steam:steam "${STEAMROOT}/linux32"; \
    chmod +x "${STEAMROOT}/linux32/steamcmd";

WORKDIR $STEAMROOT
USER steam

COPY steam.sudo /etc/sudoers.d/01-steam
COPY --chown=steam:steam steam.env ./.bashrc.d/steam.env
COPY --chown=steam:steam update.script ./update.script
COPY --chown=steam:steam entrypoint.sh ./entrypoint.sh

EXPOSE 8211/udp
VOLUME /palworld/Pal/Saved
ENTRYPOINT ["/steam/entrypoint.sh"]
