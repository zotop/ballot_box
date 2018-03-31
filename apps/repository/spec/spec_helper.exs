ESpec.configure fn(config) ->

  Ecto.Adapters.SQL.Sandbox.mode(Voting.Repo, :manual)

  config.before fn(tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Voting.Repo)
  end

  config.finally fn(_shared) ->
     Ecto.Adapters.SQL.Sandbox.checkin(Voting.Repo, [])
  end
end
