defmodule BankExWeb.UsersController do
  @moduledoc """

  """
  use BankExWeb, :controller

  action_fallback BankExWeb.FallbackController

  alias BankEx.Contexts.Users

  @doc """
  Create new user
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(%Plug.Conn{} = conn, params) when is_map(params) do
    with {:ok, user} <- Users.create(params) do
      conn |> put_status(201) |> render("user.json", user: user)
    end
  end
end
