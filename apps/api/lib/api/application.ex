defmodule Api.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do

    # List all child processes to be supervised
    children = [
       Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Api,
        options: [port: 4001]
       )
    ]

    Logger.info("Started API application")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
