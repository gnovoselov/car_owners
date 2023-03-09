# Car Owners

## Overview

We’re designing a simple application to track cars and car owners for our administrators.  As a full stack engineer, we’d like you to build a small Ruby on Rails application.  Outside of Rails, you can use any tools or libraries of your choice.

Feel free to ask as many or as few questions about the requirements as you feel are necessary.

Any code should maintain best practices, and have the ability to scale to meet load.

Please push the code up into an accessible repository of your choice.

Before moving on to Bonus Point items, please make sure the Basic Requirements are completed to your satisfaction.

## Basic Requirements

Your application must have endpoints for:

- Person maintenance.  The creation, updating, deletion, and display of one or more People.  People should have the basic attributes of: name, email, and a contact telephone number.
- Car maintenance.  The creation, updating, deletion, and display of one or more Cars.  Cars should have the basic attributes of: model, make, color, mileage, owner and a boolean flag of is_for_sale.
- Ownership history. Cars and Owners have a history of ownership.  The ownership history should be visible on both the Person and Car detail page. Ownership history should display date of sale, price, and mileage at the time of sale.

## Bonus Points

- Implement automated tests using tools of your choice.
- Database makes use of indexes and foreign keys.
- Database is seeded with sample data.
- Implement basic authentication.
- Implement table-based sorting of the cars display page and/or the ownership page.


## Installation

1. Clone the repository: `git clone https://github.com/gnovoselov/car_owners.git`
2. Build the container: `docker-compose build`
3. Create the DB and seed it with data: `docker-compose run app rails db:create db:migrate db:seed `
4. Start the server: `docker-compose up`

## Usage

Once the server is running, you can access the application at `http://localhost:3000`.


## TODO

- Enable email confirmations for registration and password reqovery
- Add dependent drop downs for car makes models
- Add async select boxes with text search for long lists like car owners, makes and models
- Allow owner creation from the Car form
- Sell car functionality (create new ownership record, e.g., when changing owner while updating car)
- Filter panels to search owners and cars at corresponding pages
- store environment variables using .env
- Create separate Docker configs for production
- Add CircleCI config
