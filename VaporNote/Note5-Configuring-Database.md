# Configuring a Database

## Choosing a database
Vapor has official, Swift-native drivers for:

- SQLite
- MySQL
- PostgreSQL
- MongoDB


## PostgreSQL
``` sh
docker run --name postgres \
  -e POSTGRES_DB=vapor_database \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5432:5432 -d postgres
```

Here’s what this does:

- Run a new container named postgres.
Specify the database name, username and password through environment variables.
Allow applications to connect to the Postgres server on its default port: 5432.
Run the server in the background as a daemon.
Use the Docker image named postgres for this container. If the image is not present on your machine, Docker automatically downloads it.

To check that your database is running, enter the following in Terminal to list all active containers:

``` sh
docker ps
```

## Configure.swift
Database configuration happens in configure.swift
``` swift
import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    let databaseName: String
    let databasePort: Int
    
    if (app.environment == .testing) {
        databaseName = "vapor-test"
        if let testPort = Environment.get("DATABASE_PORT") {
            // This uses the DATABASE_PORT environment variable if set, otherwise defaults the port to 5433. This allows you to use the port set in docker-compose-testing.yml.
            databasePort = Int(testPort) ?? 5433
        } else {
            databasePort = 5433
        }
    } else {
        databaseName = "vapor_database"
        databasePort = 5432
    }
    
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: databasePort,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? databaseName,
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    // migrations to run.
    app.migrations.add(CreateUser())
    app.migrations.add(CreateWord())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateWordCategoryPivot())
    app.migrations.add(CreateToken())
    app.migrations.add(CreateAdminUser())
    
    
    // Set the log level for the application to debug. This provides more information and enables you to see your migrations.
    app.logger.logLevel = .debug
    
    // Automatically run migrations and wait for the result. Fluent allows you to choose when to run your migrations. This is helpful when you need to schedule them, for example. You can use wait() here since you’re not running on an EventLoop.
    try await app.autoMigrate().get()//.wait()
    
    // register routes
    try routes(app)
}
```