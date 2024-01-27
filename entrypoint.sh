#!/bin/bash
export PATH=/steam/linux32:/steam/linux64:$PATH
export LD_LIBRARY_PATH=/steam/linux32:/steam/linux64

# Update steam
runuser -u steam steamcmd +quit

# Create directory structure
directories=(
  /data
  /data/Config
  /data/Config/LinuxServer
  /data/SaveGames
)

for dir in "${directories[@]}"; do
  [[ -e "$dir" ]] || install -o steam -g steam -d "$dir"
done

chown -R steam:steam /data

# Create settings
if [[ -e "/config/settings.yml" ]]; then
  /palworld/palworld-helper generate-settings /config/settings.yml /data/Config/LinuxServer/PalWorldSettings.ini
  chown steam:steam /data/Config/LinuxServer/PalWorldSettings.ini
fi

# Update palworld
runuser -u steam steamcmd +runscript /palworld/update.script

exec runuser -u steam /palworld/PalServer.sh "$@"
