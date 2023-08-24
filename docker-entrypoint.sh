#!/bin/bash
set -e

# The main entry point for Citus
/usr/local/bin/docker-entrypoint.sh postgres &

# Wait until PostgreSQL is ready
until pg_isready -U postgres; do
    echo "Waiting for PostgreSQL to start..."
    sleep 1
done

# Check if we're the coordinator
if [ "$NODE_TYPE" = "coordinator" ]; then
    # Create the Citus extension and add workers
    psql -U postgres -c "CREATE EXTENSION citus;"
    psql -U postgres -c "SELECT * from master_add_node('worker1', 5432);"
    psql -U postgres -c "SELECT * from master_add_node('worker2', 5432);"
fi

# Run the command provided to docker run
exec "$@"
