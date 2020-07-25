# runner.sh

#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

echo "Database $PGDATABASE does not exist. Creating..."
mix setup
echo "Database $PGDATABASE created."
mix swagger
echo "Swagger file created."
exec mix phx.server
