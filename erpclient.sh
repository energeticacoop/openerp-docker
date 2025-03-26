#!/bin/bash
XAUTH=$HOME/.Xauthority
touch $XAUTH
touch $HOME/.openerprc
xhost +local:docker
docker run --tty --interactive --network=host --ipc=host \
    --env DISPLAY=$DISPLAY \
    --volume $XAUTH:/root/.Xauthority \
    --volume $HOME/.openerprc:/root/.openerprc \
    --volume $HOME/openerp/sips:/root/sips:rw \
    energeticacoop/openerp-energetica
    