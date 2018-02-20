# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :task_track,
  ecto_repos: [TaskTrack.Repo]

# Configures the endpoint
config :task_track, TaskTrackWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nwKuY3CHzb639uI6UW68pU6+DfaHDvMVNr+iEgK/5LgC9qY84fN8+DuOv7/bMYPI",
  render_errors: [view: TaskTrackWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TaskTrack.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
