defmodule BankEx.Repo.Migrations.CreateTableUsers do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :cpf, :string
      add :birth_date, :string
      add :gender, :string
      add :city, :string
      add :state, :string
      add :country, :string
      add :referral_code, :string
      add :status, :string
      add :referred_user_id, references(:users, type: :binary_id)

      timestamps()
    end

    create_if_not_exists unique_index(:users, :cpf, name: :users_unique_index)
    create_if_not_exists unique_index(:users, :referral_code, name: :users_unique_referral_code)
  end

  def down do
    drop_if_exists table(:users)
  end
end
