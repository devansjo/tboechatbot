use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tboechatbot, Tboechatbot.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tboechatbot, Tboechatbot.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "tboechatbot",
  hostname: "mydbinstance.crqvhs6ptiv9.eu-central-1.rds.amazonaws.com",
  pool: Ecto.Adapters.SQL.Sandbox
