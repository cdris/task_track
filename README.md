# TaskTrack
For the most part design decisions for the UI are the same as the original version of the Task Tracker. Backend logic remained mostly the same, just shifted to accommodate api instead of html. I chose to use the Guardian library for tokens based on tutorials and documentation I found, as I had not yet seen Professor Tuck's notes on Phoenix tokens. I prefer Guardian. It's usage feels much cleaner to me.

## Set Up

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
