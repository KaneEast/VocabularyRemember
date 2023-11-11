# Foreign key constraints

## Foreign key constraints describe a link between two tables. They are frequently used for validation. Currently, there’s no link between the user table and the word table in the database. Fluent is the only thing that has knowledge of the link.

## Using foreign key constraints has a number of benefits:

- It ensures you can’t create words with users that don’t exist.
- You can’t delete users until you’ve deleted all their words.
- You can’t delete the user table until you’ve deleted the word table.

