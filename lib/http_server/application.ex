defmodule HttpServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    port = Application.fetch_env!(:http_server, :port)
    children = [
      {Task.Supervisor, name: HttpServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> HttpServer.accept(port) end}, restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HttpServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
