defmodule BankExWeb.UsersController do
  @moduledoc """

  """
  use BankExWeb, :controller

  action_fallback BankExWeb.FallbackController

  alias BankEx.Services.Users

  @doc """
  Create new user
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(%Plug.Conn{} = conn, %{"referral_code" => referral_code} = params) when is_map(params) do
    with {:ok, referral_user} <- Users.get_by_referral_code(referral_code),
         params <- Map.put(params, "referred_user_id", referral_user.id),
         {:ok, user} <- Users.create(params) do
      conn |> put_status(201) |> render("user.json", user: user)
    end
  end
  def create(%Plug.Conn{} = conn, params) when is_map(params) do
    with {:ok, user} <- Users.create(params) do
      conn |> put_status(201) |> render("user.json", user: user)
    end
  end
end
