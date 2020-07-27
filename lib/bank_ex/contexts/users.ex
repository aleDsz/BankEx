defmodule BankEx.Contexts.Users do
  @moduledoc """
  The User's context.
  """
  import Ecto.Query

  alias BankEx.Repo
  alias BankEx.Schemas.User

  @preload [:referred_user]

  @doc """
  Retrieve an user by ID
  """
  @spec get(user_id :: Ecto.UUID.t()) :: {:ok, User.t()} | {:error, term()}
  def get(user_id) do
    from(
      m in User,
      where: m.id == ^user_id,
      preload: ^@preload
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Retrieve an user by referral code
  """
  @spec get_by_referral_code(referral_code :: binary()) :: {:ok, User.t()} | {:error, term()}
  def get_by_referral_code(referral_code) do
    from(
      m in User,
      where: m.referral_code == ^referral_code,
      preload: ^@preload
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Retrieve an user by CPF
  """
  @spec get_by_cpf(cpf :: binary()) :: {:ok, User.t()} | {:error, term()}
  def get_by_cpf(cpf) do
    from(
      m in User,
      where: m.cpf == ^cpf,
      preload: ^@preload
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Create new user
  """
  @spec create(map()) :: {:ok, User.t()} | {:error, term()}
  def create(attrs) when is_map(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        user = Repo.preload(user, @preload)
        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end
  end
end
