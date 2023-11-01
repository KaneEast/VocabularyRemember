import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    // Add CreateAcronym to the list of migrations to run.
    app.migrations.add(CreateWord())
      
    // Set the log level for the application to debug. This provides more information and enables you to see your migrations.
    app.logger.logLevel = .debug

    // Automatically run migrations and wait for the result. Fluent allows you to choose when to run your migrations. This is helpful when you need to schedule them, for example. You can use wait() here since you’re not running on an EventLoop.
    try app.autoMigrate().wait()


    // register routes
    try routes(app)
}
