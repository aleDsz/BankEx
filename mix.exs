defmodule BankEx.MixProject do
  use Mix.Project

  def project, do: [
    app: :bank_ex,
    version: "0.1.0",
    elixir: "~> 1.8",
    elixirc_paths: elixirc_paths(Mix.env()),
    compilers: [:phoenix] ++ Mix.compilers(),
    start_permanent: Mix.env() == :prod,
    aliases: aliases(),
    deps: deps()
  ]

  def application, do: [
    mod: {BankEx.Application, []},
    extra_applications: [:logger, :runtime_tools]
  ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # API
      {:phoenix, "~> 1.5.3"},
      {:phoenix_ecto, "~> 4.1"},
      {:plug_cowboy, "~> 2.0"},

      # Database
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      
      # Telemetry
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},

      # Serializers
      {:jason, "~> 1.0"},

      # Documentation
      {:phoenix_swagger, github: "xerions/phoenix_swagger", branch: "master"},

      # Testing
      {:ex_machina, "~> 2.4", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
    ]
  end

  defp aliases do
    [
      setup: ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate --quiet"],
      swagger: ["phx.swagger.generate ./priv/static/swagger.json --router BankExWeb.Router --endpoint BankExWeb.Endpoint"]
    ]
  end
end
