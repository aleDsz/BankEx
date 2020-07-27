defmodule BankEx.Services.UserIndications do
  @moduledoc """
  The UserIndication service context to handle business logic
  """

  alias BankEx.Schemas.UserIndication
  alias BankEx.Contexts.UserIndications

  @doc """
  Retrieve user indications from referral code
  """
  @spec retrieve_all_from_user_referral_code(referral_code :: binary()) :: {:ok, list(UserIndication.t())} | {:error, term()}
  def retrieve_all_from_user_referral_code(referral_code) do
    case UserIndications.retrieve_all_from_user_referral_code(referral_code) do
      {:ok, user_indications} ->
        {:ok, user_indications}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Create new UserIndication
  """
  @spec create(map()) :: {:ok, UserIndication.t()} | {:error, term()}
  def create(params) do
    case UserIndications.create(params) do
      {:ok, user_indication} ->
        {:ok, user_indication}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
