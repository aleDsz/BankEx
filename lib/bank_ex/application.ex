defmodule BankEx.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BankEx.Repo,
      BankExWeb.Telemetry,
      {Phoenix.PubSub, name: BankEx.PubSub},
      BankExWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: BankEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BankExWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
