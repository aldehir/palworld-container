#!/bin/bash
export PATH=/steam/linux32:/steam/linux64:$PATH
export LD_LIBRARY_PATH=/steam/linux32:/steam/linux64

# Create directory structure
directories=(
  /config
  /palworld
  /palworld/Pal/Saved
  /palworld/Pal/Saved/Config
  /palworld/Pal/Saved/Config/LinuxServer
  /palworld/Pal/Saved/SaveGames
)

for dir in "${directories[@]}"; do
  [[ -e "$dir" ]] || install -o steam -g steam -d "$dir"
done

chown -R steam:steam /config /palworld

# Update steam
runuser -u steam steamcmd +quit

# Update palworld
runuser -u steam steamcmd +runscript /palworld-scripts/update.script

# Create settings
if [[ -e "/config/settings.yml" ]]; then
  /palworld-scripts/palworld-helper generate-settings \
    /config/settings.yml \
    /palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

  chown steam:steam /palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
fi

exec runuser -u steam -- /palworld/PalServer.sh "$@"
