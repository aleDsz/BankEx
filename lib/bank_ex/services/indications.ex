defmodule BankEx.Services.Indications do
  @moduledoc """
  Handle user indications before creating new user
  """
  require Logger

  alias Ecto.Multi
  alias BankEx.Repo

  alias BankEx.Schemas.{User, UserIndication}
  alias BankEx.Services.{Users, UserIndications}

  @doc """
  Create new user and an user indication 
  """
  @spec create(map()) :: {:ok, User.t()} | {:error, term()}
  def create(%{"referral_code" => _referral_code} = params) do
    Multi.new()
    |> Multi.run(:user, (fn _repo, _entities -> create_user(params) end))
    |> Multi.run(:indication, &create_indication/2)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} ->
        {:ok, user}

      {:error, _step, reason, _changes} ->
        {:error, reason}
    end
  end

  @spec create_user(map()) :: {:ok, User.t()} | {:error, term()}
  defp create_user(attrs) do
    case Users.create(attrs) do
      {:ok, user} ->
        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec create_indication(module(), map()) :: {:ok, UserIndication.t()} | {:error, term()}
  def create_indication(_repo, %{user: %{id: user_id, referred_user: %{id: referral_user_id}}}) do
    %{
      referral_user_id: referral_user_id,
      user_id: user_id
    }
    |> UserIndications.create()
    |> case do
      {:ok, user_indication} ->
        {:ok, user_indication}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
