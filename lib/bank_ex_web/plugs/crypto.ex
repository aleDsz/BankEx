defmodule BankExWeb.Plugs.Crypto do
  @moduledoc """
  Implement the crypto to requests
  """
  use Plug.Builder

  @doc false
  def init(opts), do: opts

  @doc false
  def call(%Plug.Conn{} = conn, _opts) do
    conn
    |> do_crypto()
  end

  defp do_crypto(%Plug.Conn{params: params} = conn) do
    params =
      params
      |> Enum.map(fn
        {key, value} when key in ~w(cpf name email birth_date) and not is_nil(value) ->
          {key, encrypt(value)}

        {key, value} ->
          {key, value}
      end)
      |> Enum.into(%{})

    conn
    |> Map.put(:params, params)
  end
  defp do_crypto(%Plug.Conn{} = conn), do: conn

  defp encrypt(value), do: value |> BankEx.Services.Crypto.encrypt() 
end
