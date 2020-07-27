defmodule BankEx.Handlers.AuthError do
  @moduledoc """
  Handle Guardian authentication errors
  """
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler
  
  @doc """
  Send error when user is unauthorized
  """
  @impl Guardian.Plug.ErrorHandler
  def auth_error(%Plug.Conn{} = conn, _reason, _opts) do
    body = Jason.encode!(%{
      errors: %{
        detail: "Unauthorized"
      }
    })

    conn
    |> put_resp_content_type("application/json")
    |> resp(401, body)
    |> halt()
  end
end
