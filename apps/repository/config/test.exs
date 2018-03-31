use Mix.Config

config :repository, Voting.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "repository_test_repo",
  hostname: "localhost",
  username: "admin",
  password: "",
  pool: Ecto.Adapters.SQL.Sandbox
