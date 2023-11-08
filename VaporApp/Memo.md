# Auth

## Bearer authentication
Bearer authentication is a mechanism for sending a token to authenticate requests.
It uses the Authorization header, like HTTP basic authentication,
but the header looks like Authorization: Bearer <TOKEN STRING>.

# Database seeding
When you deploy your application, or next revert the database, you won’t have any users in the database.

But, you can’t create a new user since that route requires authentication! One way to solve this is to seed the database and create a user when the application first boots up. In Vapor, you do this with a migration.

# admin token: AOM03FS90G7HgW0A0Ze0Dw==
