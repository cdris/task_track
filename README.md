# TaskTrack

## Design Decisions

### Users

Users have the following attributes:

* Name: name used for display purposes
* Email: user's email address, must be unique
* Level: employee level, an employee with a higher level is ranked above an employee with a lower level (i.e. a senior employee would have a higher level than a new grad hire)
* Manager ID: id of the manager for this user

The first three fields are provided upon account creation. Users can view a list of all users by navigating to the Directory, and may choose to set themselves as manager for any unmanaged users of a lower level. A user does not have to have a manager and starts out with no manager.

### Assigning Tasks

USERS MAY ASSIGN THEMSELVES TASKS! I know this is contrary to the posts on piazza, however a task tracker where users can't assign tasks to themselves is lame. Tasks that a user assigns to themselves are only visible to that user, and are not visible to managers.

Users can also assign tasks to the users they manage. If a user tries to assign a task to someone other than themselves or someone they manage, a permissions error will be displayed.

### Time Tracking

Aggregate time worked is displayed in minutes on the task list view. Detailed time worked is visible from the individual task view.

The time worked table displays the individual time blocks for a task. Each time block can be edited or deleted. Pressing edit will change the fields of the row into input fields. Pressing submit will submit the changes. If the view does not change, there has been an error with your input (most likely empty fields or date formatting). Pressing delete will bring up a confirmation dialog, and delete the time block on confirmation.

New time blocks can be created in two ways. Pressing "Add Manually" will add a form row to the bottom of the table. Pressing submit from this form row will submit the new time block. If the view does not change, there has been an error with your input. Pressing "Use Tracker" will bring up the time tracker. Pressing cancel on this modal at any time will cancel creation of the time block. Pressing start will display the start time for the new block. Pressing end will submit the new time block. Because this time tracker is only granular to the minute, pressing end will do nothing if less than a minute has passed.

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
