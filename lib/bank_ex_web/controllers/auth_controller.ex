defmodule BankExWeb.AuthController do
  @moduledoc """
  The auth controller context
  """
  use BankExWeb, :controller
  # use BankExWeb.Swagger.AuthController 

  action_fallback BankExWeb.FallbackController

  alias BankEx.Services.Authentications

  @doc """
  Authenticate user from parameters
  """
  @spec login(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, term()}
  def login(%Plug.Conn{} = conn, params) when is_map(params) do
    with {:ok, token} <- Authentications.login(params) do
      conn |> put_status(201) |> render("token.json", token: token)
    end
  end
end
