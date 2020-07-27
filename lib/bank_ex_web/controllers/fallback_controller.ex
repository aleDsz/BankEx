defmodule BankExWeb.FallbackController do
  @moduledoc """
  The fallback action for controllers
  """
  use BankExWeb, :controller

  @doc """
  Handle errors from controller response
  """
  @spec call(Plug.Conn.t(), tuple()) :: Plug.Conn.t()
  def call(%Plug.Conn{} = conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankExWeb.ErrorView)
    |> render("error.json", changeset: changeset)
  end
  def call(%Plug.Conn{} = conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BankExWeb.ErrorView)
    |> render("404.json")
  end
  def call(%Plug.Conn{} = conn, {:error, message}) when is_binary(message) do
    conn
    |> put_status(:bad_request)
    |> put_view(BankExWeb.ErrorView)
    |> render("400.json", message: message)
  end
end
