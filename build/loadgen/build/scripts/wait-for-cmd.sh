#!/bin/bash
WAIT_CMD=$1
WAIT_TIME_S=${2:-10}
WAIT_INTERVAL_S=${WAIT_INTERVAL_S:-1}
WAIT_NUM_LOOPS=$(($WAIT_TIME_S / $WAIT_INTERVAL_S))

if [ $WAIT_INTERVAL_S -gt $WAIT_TIME_S ]; then
    echo "Error: \$WAIT_INTERVAL_S must be <= \$WAIT_TIME_S"
    exit 1
fi

is_ready() {
    eval "$WAIT_CMD"
}

i=0
while ! is_ready; do
    i=$(($i + 1))
    if [ "$i" -ge "$WAIT_NUM_LOOPS" ]; then
        echo "Error: '${WAIT_CMD}' still not ready after ${WAIT_TIME_S}s"
        exit 1
    fi

    sleep $WAIT_INTERVAL_S
done