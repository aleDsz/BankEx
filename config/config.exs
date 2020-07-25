# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank_ex,
  ecto_repos: [BankEx.Repo]

# Configures the endpoint
config :bank_ex, BankExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RBoY36zNOMCh53+FPewbLWCJVe/YKoidGlHOm/67QUI+njpMZor9R52ye6UgpR2d",
  render_errors: [view: BankExWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankEx.PubSub,
  live_view: [signing_salt: "bGzfBPsw"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
