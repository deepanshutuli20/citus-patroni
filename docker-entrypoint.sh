#!/bin/bash

if [ "$USE_PATRONI" = "true" ]; then
    # Modify the Patroni template configuration using environment variables, if necessary
    envsubst < /etc/patroni.yml.template > /etc/patroni.yml
    exec ${VENV_PATH}/bin/patroni /etc/patroni.yml
else
    exec docker-entrypoint.sh postgres -c shared_preload_libraries=citus
fi
