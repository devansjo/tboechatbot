# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
#config :tboechatbot,
#  ecto_repos: [Tboechatbot.PhraseRepo]

# Configures the endpoint
config :tboechatbot, Tboechatbot.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ufRAIEYVbKhBpK3TT6HVpN3yghcc2TNM8pTeHC7sAzBK//xH58GMFxdtiBMCXChQ",
  render_errors: [view: Tboechatbot.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tboechatbot.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
