defmodule BankEx.Services.Users do
  @moduledoc """
  The User service context to handle business logic
  """

  alias BankEx.Schemas.User
  alias BankEx.Contexts.Users

  @doc """
  Retrieve user by ID
  """
  @spec get(user_id :: Ecto.UUID.t()) :: {:ok, User.t()} | {:error, term()}
  def get(user_id) do
    case Users.get(user_id) do
      {:ok, user} ->
        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Retrieve user by CPF
  """
  @spec get_by_cpf(cpf :: binary()) :: {:ok, User.t()} | {:error, term()}
  def get_by_cpf(cpf) do
    case Users.get_by_cpf(cpf) do
      {:ok, user} ->
        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end
  
  @doc """
  Retrieve user by Referral Code 
  """
  @spec get_by_referral_code(referral_code :: binary()) :: {:ok, User.t()} | {:error, term()} 
  def get_by_referral_code(referral_code) do
    case Users.get_by_referral_code(referral_code) do
      {:ok, user} ->
        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Create new User
  """
  @spec create(map()) :: {:ok, User.t()} | {:error, term()}
  def create(%{"cpf" => cpf} = params) do
    case Users.get_by_cpf(cpf) do
      {:ok, _user} -> Users.update(params)
      {:error, _reason} -> Users.create(params)
    end
  end
  def create(params),
    do: Users.create(params)

  @doc """
  Update existent user
  """
  @spec update(map()) :: {:ok, User.t()} | {:error, term()}
  def update(params) do
    case Users.update(params) do
      {:ok, user} ->
        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
