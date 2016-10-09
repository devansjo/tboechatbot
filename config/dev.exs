use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :tboechatbot, Tboechatbot.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :tboechatbot, Tboechatbot.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure redis
config :redix,
    url: "redis://localhost:6379"

# Configure your database
#config :tboechatbot, Tboechatbot.PhrasesRepo,
#    adapter: Ecto.Adapters.MySQL,
#    username: "root",
#    password: "",
#    database: "tboechatbot",
#    hostname: "mydbinstance.crqvhs6ptiv9.eu-central-1.rds.amazonaws.com",
#    pool_size: 10

#config :tboechatbot, Tboechatbot.ConversationRepo,
#    adapter: Ecto.Adapters.MySQL,
#    username: "root",
#    password: "",
#    database: "tboechatbot",
#    hostname: "mydbinstance.crqvhs6ptiv9.eu-central-1.rds.amazonaws.com",
#    pool_size: 10

# Configure Smooch.IO
config :tboechatbot,
    smooch_key: "app_57cabc821210d55200ecabbc",
    smooch_secret: "5frRGlc_AejucffB0XJ1hHKd",
    smooch_api_jwt: "eyJ0eXAiOiJKV1QiLCJraWQiOiJhcHBfNTdjYWJjODIxMjEwZDU1MjAwZWNhYmJjIiwiYWxnIjoiSFMyNTYifQ.eyJzY29wZSI6ImFwcCJ9.iS47tayYNRHt1w1JoEKh93-fa1m9WQ6zj4FdmLUtSpg",
    smooch_app_token: "apqj90hg11umriffcefcurzem",
    smooch_api_url: "https://api.smooch.io/v1",
    chat_api_url: "http://localhost:4001/api",
    legacy_api_url: "http://tboe.dev:4040/bookbuilder",
    bookbuilder_url: "http://tboe.dev:4000/bookbuilder/chat/edit/"