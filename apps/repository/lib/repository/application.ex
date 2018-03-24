defmodule Repository.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      Voting.Repo
    ]

    Logger.info("Started Repository application")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Repository.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
