use Mix.Config
config :repository, ecto_repos: [Voting.Repo]

config :repository, Voting.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "repository_repo",
  username: "admin",
  password: "",
  hostname: "localhost"
