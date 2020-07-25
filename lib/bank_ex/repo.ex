defmodule BankEx.Repo do
  use Ecto.Repo,
    otp_app: :bank_ex,
    adapter: Ecto.Adapters.Postgres
end
