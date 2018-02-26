# TaskTrack

## Design Decisions

### Users

Users have the following attributes:

* Name: name used for display purposes
* Email: user's email address, must be unique
* Level: employee level, an employee with a higher level is ranked above an employee with a lower level (i.e. a senior employee would have a higher level than a new grad hire)
* Manager ID: id of the manager for this user

The first three fields are provided upon account creation. Employees will be able to view a list of unmanaged employees with lower employee levels than them, and may choose to set themselves as manager for these employees.

Users can only assign tasks to their employees and to themselves (because I should be able to keep track of my own personal tasks too).

## Run Locally

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
