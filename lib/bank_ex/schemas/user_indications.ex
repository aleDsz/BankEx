defmodule BankEx.Schemas.UserIndication do
  @moduledoc """
  Schema definition for table `user_indications`
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BankEx.Schemas.User

  @typedoc """
  UserIndication schema type
  """
  @type t :: %__MODULE__{
    id: Ecto.UUID.type(),
    referral_user: __MODULE__.t(),
    referral_user_id: Ecto.UUID.type(),
    user: __MODULE__.t(),
    user_id: Ecto.UUID.type(),
    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_indications" do
    belongs_to :referral_user, User
    belongs_to :user, User

    timestamps()
  end

  @doc """
  Execute validations with UserIndication schema
  """
  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = schema, attrs \\ %{}) when is_map(attrs) do
    schema
    |> cast(attrs, [:referral_user_id, :user_id])
    |> validate_required([:referral_user_id, :user_id])
    |> unique_constraint([:referral_user_id, :user_id], name: :user_indications_unique_index)
    |> foreign_key_constraint(:referral_user_id, name: :user_indications_referral_user_id_fkey)
    |> foreign_key_constraint(:user_id, name: :user_indications_user_id_fkey)
  end 
end
