defmodule BankEx.Contexts.UserIndications do
  @moduledoc """
  The UserIndication's context.
  """
  import Ecto.Query

  alias BankEx.Repo
  alias BankEx.Schemas.UserIndication

  @preload [:referral_user, :user, user: [:referred_user]]

  @doc """
  Retrieve user indications from referral code 
  """
  @spec retrieve_all_from_user_referral_code(referral_code :: binary()) :: {:ok, list(UserIndication.t())} | {:error, term()}
  def retrieve_all_from_user_referral_code(referral_code) do
    from(
      m in UserIndication,
      join: ru in assoc(m, :referral_user),
      join: u in assoc(m, :user),
      where: ru.referral_code == ^referral_code,
      select: u
    )
    |> Repo.all()
    |> case do
      [] ->
        {:error, :not_found}

      users ->
        {:ok, users}
    end
  end

  @doc """
  Create new user indication
  """
  @spec create(map()) :: {:ok, UserIndication.t()} | {:error, term()}
  def create(attrs) when is_map(attrs) do
    %UserIndication{}
    |> UserIndication.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user_indication} ->
        user_indication = Repo.preload(user_indication, @preload)
        {:ok, user_indication}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
