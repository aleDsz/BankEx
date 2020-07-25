defmodule BankEx.Schemas.User do
  @moduledoc """
  Schema definition for table `users`
  """
  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  User schema type
  """
  @type t :: %__MODULE__{
    id: Ecto.UUID.type(),
    name: binary(),
    email: binary(),
    cpf: binary(),
    birth_date: binary(),
    gender: binary(),
    city: binary(),
    state: binary(),
    country: binary(),
    referral_code: binary(),
    status: binary(),
    referred_user: __MODULE__.t(),
    referred_user_id: Ecto.UUID.type(),
    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  @fields ~w(
    id
    name
    email
    cpf
    birth_date
    gender
    city
    state
    country
    status
  )a

  @derive {Jason.Encoder, only: @fields}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @statuses ~w(pending completed)
  @genders ~w(M F O)

  schema "users" do
    field :name, :string
    field :email, :string
    field :cpf, :string
    field :birth_date, :string
    field :gender, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :referral_code, :string
    field :status, :string, default: "pending"

    belongs_to :referred_user, __MODULE__

    timestamps()
  end

  @doc """
  Execute validations with User schema
  """
  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = schema, attrs \\ %{}) when is_map(attrs) do
    schema
    |> cast(attrs, [:name, :email, :cpf, :birth_date, :gender, :city, :state, :country, :status])
    |> validate_required([:cpf])
    |> validate_inclusion(:gender, @genders)
    |> validate_cpf()
    |> define_status()
    |> validate_inclusion(:status, @statuses)
    |> unique_constraint(:cpf, name: :users_unique_index)
    |> unique_constraint(:referral_code, name: :users_unique_referral_code)
    |> foreign_key_constraint(:referred_user_id, name: :users_referred_user_id_fkey)
    |> generate_referral_code()
  end 

  defp validate_cpf(%Ecto.Changeset{} = changeset) do
    case get_change(changeset, :cpf) do
      nil ->
        changeset

      cpf ->
        cpf = BankEx.Services.Crypto.decrypt(cpf)

        if Brcpfcnpj.cpf_valid?(%Cpf{number: cpf}) do
          changeset
        else
          changeset |> add_error(:cpf, "invalid cpf")
        end
    end
  end

  defp define_status(%Ecto.Changeset{valid?: false} = changeset),
    do: changeset
  defp define_status(%Ecto.Changeset{valid?: true, changes: changes} = changeset) do
    fields =
      @fields
      |> List.delete(:id)
      |> List.delete(:status)

    if length(fields) != length(Map.keys(changes)) do
      changeset
      |> put_change(:status, "pending")
    else
      status =
        changes
        |> Enum.reduce_while("peding", fn {key, value}, _status ->
          cond do
            Enum.member?(fields, key) and not is_nil(value) ->
              {:cont, "completed"}

            true ->
              {:halt, "pending"}
          end
        end)

      changeset
      |> put_change(:status, status)
    end
  end

  defp generate_referral_code(%Ecto.Changeset{valid?: false} = changeset),
    do: changeset
  defp generate_referral_code(%Ecto.Changeset{valid?: true} = changeset) do
    case get_field(changeset, :referral_code) do
      nil ->
        referral_code = Ecto.UUID.generate() |> :erlang.phash2() |> to_string()

        changeset
        |> put_change(:referral_code, referral_code)

      _ ->
        changeset
    end
  end
end
