defmodule BankExWeb.UsersController do
  @moduledoc """
  The user controller context
  """
  use BankExWeb, :controller
  use BankExWeb.Swagger.UsersController 

  action_fallback BankExWeb.FallbackController

  alias BankEx.Services.{Users, UserIndications, Indications}

  @doc """
  Create new user
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, term()}
  def create(%Plug.Conn{} = conn, %{"referral_code" => referral_code} = params) when is_map(params) do
    with {:ok, referral_user} <- Users.get_by_referral_code(referral_code),
         params <- Map.put(params, "referred_user_id", referral_user.id),
         {:ok, user} <- Indications.create(params) do
      conn |> put_status(201) |> render("user.json", user: user)
    end
  end
  def create(%Plug.Conn{} = conn, params) when is_map(params) do
    with {:ok, user} <- Users.create(params) do
      conn |> put_status(201) |> render("user.json", user: user)
    end
  end

  @doc """
  Retrieve all indications from user
  """
  @spec indications(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, term()}
  def indications(%Plug.Conn{} = conn, %{"referral_code" => referral_code}) do
    case Users.get_by_referral_code(referral_code) do
      {:ok, %{status: "completed"}} ->
        with {:ok, users} <- UserIndications.retrieve_all_from_user_referral_code(referral_code) do
          conn |> put_status(200) |> render("users.json", users: users)
        end

      {:ok, _user} ->
        {:error, "User doesn't have the completed status"}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
