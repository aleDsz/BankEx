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
  Create new user
  """
  @spec create(map()) :: {:ok, User.t()} | {:error, term()}
  def create(attrs) when is_map(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
