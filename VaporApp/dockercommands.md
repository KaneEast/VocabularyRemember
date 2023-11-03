``` sh
# Stop the running Docker container postgres. This is the container currently running the database.
docker stop postgres
# Remove the Docker container postgres to delete any existing data.
docker rm postgres
# Start a new Docker container running PostgreSQL. For more information, see Chapter 6, “Configuring a Database”.
docker run --name postgres -e POSTGRES_DB=vapor_database \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5432:5432 -d postgres

```

---------------------

``` sh
// developing database
docker run --name postgres \
  -e POSTGRES_DB=vapor_database \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5432:5432 -d postgres

```

``` sh
// test database
docker run --name postgres-test \
  -e POSTGRES_DB=vapor-test \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5433:5432 -d postgres
```

```
Run a new container named postgres.
Specify the database name, username and password through environment variables.
Allow applications to connect to the Postgres server on its default port: 5432.
Run the server in the background as a daemon.
Use the Docker image named postgres for this container. If the image is not present on your machine, Docker automatically downloads it.
```

----
To check that your database is running, enter the following in Terminal to list all active containers:
```
docker ps
```


## To test your application in Linux, open Terminal and type the following:
``` sh
# Build the different docker containers using the compose file created earlier.
docker-compose -f docker-compose-testing.yml build
# Spin up the different containers from the compose file created earlier and run the tests.
# --abort-on-container-exit tells Docker Compose to stop the postgres container when the til-app container stops. 
# The postgres container used for this test is different from, and doesn’t conflict with,
# the one you’ve been using during development.
docker-compose -f docker-compose-testing.yml up \
  --abort-on-container-exit

```

# Postgres Migration
``` sh
# Stop the running Docker container postgres. This is the container currently running the database.
docker stop postgres
# Remove the Docker container postgres to delete any existing data.
docker rm postgres
# Start a new Docker container running PostgreSQL. For more information, see Chapter 6, “Configuring a Database”.
docker run --name postgres -e POSTGRES_DB=vapor_database \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5432:5432 -d postgres

```


# start with a fresh database.
``` sh
# Stop and remove the test PostgreSQL container, if it exists, so you start with a fresh database.
docker rm  -f postgres-test
# Run the test container again
docker run --name postgres-test -e POSTGRES_DB=vapor-test \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5433:5432 -d postgres

```