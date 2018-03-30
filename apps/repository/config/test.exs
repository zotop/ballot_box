use Mix.Config

config :repository, Voting.Repo, pool: Ecto.Adapters.SQL.Sandbox,
        ownership_timeout: 60_000
