## Fluent & Persisting Models

### Fluent
Fluent is Vapor’s ORM (Object Relational Mapping) tool. It serves as an abstraction layer between the Vapor application and the database, simplifying database interactions. Using an ORM like Fluent offers numerous advantages:

- **Ease of Interaction**: No need to directly use the database! Traditional direct interactions require database queries as strings, which lack type-safety and are cumbersome in Swift.
``` swift
// Traditional query as a string
let queryString = "SELECT * FROM users WHERE id = 1"
// Fluent "Swifty" way
User.query(on: db).filter(\.$id == 1).all()
```
  
- **Flexibility**: Fluent supports multiple database engines, even within the same application. This eliminates the need to write queries manually, facilitating a more "Swifty" interaction with models.
``` swift
// Fluent "Swifty" way
User.query(on: db).filter(\.$id == 1).all()
```
  
- **Models**: These are Swift representations of your data and play a pivotal role in Fluent. Models represent objects, such as user profiles, that you store and retrieve from your database. Fluent ensures type-safety by returning and using these models during database interactions.
``` swift
final class User: Model {
    static let schema = "users"
    @ID var id: UUID?
    @Field(key: "name") var name: String
}
```
  
- **Advanced Features in Fluent 4**:
  - **@ID**: This property wrapper designates a property as the table ID. It's crucial for queries, especially when locating models. By default, the ID should be a UUID and named `id`.
    
  - **@Field**: Represents a generic column in the database. Fluent uses this for query operations with filters. It allows for updating individual fields in a model and selecting specific fields from the database. For non-optional properties, always use @Field. For optional properties, opt for @OptionalField.
    
- **Migrations**: For storing a model in the database, its corresponding table needs to be created. Fluent accomplishes this using migrations. Migrations ensure dependable, testable, and consistent modifications to your database. They're essential for crafting a database schema for your models, seeding data, or altering saved models.
``` swift
struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
```
