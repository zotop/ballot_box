use Mix.Config

config :repository, Voting.Repo,
  pool: Ecto.Adapters.SQL.Sandbox
