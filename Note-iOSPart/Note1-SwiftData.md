# Swift Data

Apple introduced SwiftData in WWDC 23. Similar to SwiftUI, SwiftData takes declarative approach. SwiftData makes data persistence easy by letting us model and manage data using declarative code eliminating the need of using model schema design files and bringing in the querying and filtering of data purely in Swift code.

SwiftData is designed to work with both UIKit and SwiftUI and it seamlessly integrate with SwiftUI.

SwiftData is built on the top of Core Data but it brings modern approach to the data persistence by providing native APIs written in Swift language.

SwiftData uses macros to generate code. Macros are another powerful feature introduced in WWDC 23 and they are used to generate fast, efficient and safe code.

SwiftData automatically builds a schema using our models and maps their fields efficiently to the underlying storage. Objects managed by SwiftData are fetched from the database when needed and automatically saved at the right moment, with no additional work on our part.


- SwiftData can automatically infer many relationships using declarations like @Attribute(.unique) to describe constraints for our data models.

## There are a few types of entity relationships.

- One to One(1:1) Relationship: In a one-to-one relationship, each entity instance on one side of the relationship is associated with exactly one entity instance on the other side, and vice versa. For example, we might have a “Person” entity with a one-to-one relationship to a “Passport” entity, where each person has only one passport.

- One to Many(1:N) Relationship: In a one-to-many relationship, each entity instance on one side of the relationship can be associated with multiple entity instances on the other side, but each entity instance on the other side is associated with only one entity instance from the first side. For example, we might have a “Department” entity with a one-to-many relationship to an “Employee” entity, where each department can have many employees, but each employee belongs to only one department.

- Many to One(N:1) Relationship: This is the inverse of a one-to-many relationship. Each entity instance on one side is associated with one entity instance on the other side, but each entity instance on the other side can be associated with multiple entity instances on the first side. Using the same “Department” and “Employee” example, this would mean that each employee belongs to one department, but multiple employees can belong to the same department.

- Many to Many(N:N) Relationship: In a many-to-many relationship, multiple entity instances on one side can be associated with multiple entity instances on the other side. For example, we might have a “Student” entity, a “Course” entity, and a “Registration” entity to represent the many-to-many relationship between students and courses, where each registration links a student to a course.


