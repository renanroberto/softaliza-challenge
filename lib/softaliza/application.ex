defmodule Softaliza.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Softaliza.Repo,
      # Start the Telemetry supervisor
      SoftalizaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Softaliza.PubSub},
      # Start the Endpoint (http/https)
      SoftalizaWeb.Endpoint
      # Start a worker by calling: Softaliza.Worker.start_link(arg)
      # {Softaliza.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Softaliza.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SoftalizaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
