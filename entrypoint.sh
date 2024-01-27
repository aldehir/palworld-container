#!/bin/bash
export PATH=$HOME/linux32:$HOME/linux64:$PATH
export LD_LIBRARY_PATH=$HOME/linux32:$HOME/linux64

# Update steam, we need to run this at least twice since the second one pulls
# in additional dependencies
steamcmd +quit
steamcmd +quit

# Update palworld
steamcmd +runscript update.script

exec /palworld/PalServer.sh "$@"
