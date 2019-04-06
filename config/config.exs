# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
#
# 'secret_key_base gets' gets renewed by the
# 'prod.secret.exs' configuration file. So,
# no problem for leaving this key in here.
config :game_of_life, GameOfLifeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wQz07/DQmnaSzHVl4DkHHyXwl+UDqds6MB4Wk//a9xghqFyLIBtIXZke49jdbFzq",
  render_errors: [view: GameOfLifeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GameOfLife.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Signing salt for Phoenix LiveView to prevent MITM attack
#
# 'signing salt' gets renewed by the
# 'prod.secret.exs' configuration file.
# So, no problem for leaving this key
# in here.
config :game_of_life, GameOfLifeWeb.Endpoint,
  live_view: [
    signing_salt: "7uRHKflDcem6LRqtqQQ/l9Ji/LZokwoy"
  ]

# Tell Phoenix to use the LiveView template engine (leex)
config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
