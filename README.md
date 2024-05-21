# My Times


This is a backend Server for an Application My Times an Extension which allows for managing websites with specific restrictions and timeouts for users. It provides endpoints to create, update, and retrieve websites with their respective settings.

## Requirements

- Ruby 2.7.2 or later
- Rails 6.1 or later
- PostgreSQL (or any other preferred database)

## Getting Started

### Clone the repository

```bash
git clone https://github.com/kishore161003/My-Times-Backend.git
cd My-Times-Backend

#Install  dependecies

bundle install

#Set Up the database

rails db:create
rails db:migrate

#Start the Rails Server

rails server

The server will start on http://localhost:3000.

```
## API EndPoints

List of Endpoints

GET /websites - Retrieve all websites.

POST /websites - Create a new website.

PUT /websites/:id - Update an existing website.

DELETE /websites/:id - Delete a website.

GET /websites/with_restriction_or_timeout/:user_id - Retrieve websites with restrictions or timeouts for a specific user.

PUT /websites/update_timeout_data - Update or create a website with a specific timeout.

PUT /websites/update_restriction_data - Update or create a website with a specific restriction.

POST/update_data - for continous data updating from the extension to server

// other Statistical routes also Included. refer My-Times-Backend/config/routes.rb for routes

## Running Tests
```bash
rails test
```

 
 for FrontEnd Refer - [GitHub Repository](https://github.com/kishore161003/my-times-frontend)
 
 for Extension Refer - [GitHub Repository](https://github.com/kishore161003/my-times-extension)


