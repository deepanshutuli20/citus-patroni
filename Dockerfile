# Use the Citus base image
FROM citusdata/citus:latest

# Set environment variables (can be overridden when running the container)
ENV POSTGRES_USER=citus
ENV POSTGRES_PASSWORD=citus
ENV PATRONI_SCOPE=pg_cluster
ENV PATRONI_NAME=pg_node
ENV PATRONI_ETCD_URL=http://etcd:2379
ENV VENV_PATH=/opt/patroni_venv

# Install necessary packages for Patroni and its backends (etcd here)
RUN apt-get update && apt-get install -y python3-venv python3-dev libpq-dev curl && \
    python3 -m venv ${VENV_PATH} && \
    ${VENV_PATH}/bin/pip install patroni[etcd]

# Copy a Patroni configuration template (you need to create this!)
COPY patroni.yml.template /etc/patroni.yml.template

# Use an entrypoint script to start either Citus standalone or with Patroni
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
