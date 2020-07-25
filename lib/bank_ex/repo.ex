defmodule BankEx.Repo do
  use Ecto.Repo,
    otp_app: :bank_ex,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    Application.ensure_all_started(:ecto_sql)
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
