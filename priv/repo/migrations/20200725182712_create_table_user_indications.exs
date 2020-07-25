defmodule BankEx.Repo.Migrations.CreateTableUserIndications do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:user_indications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :referral_user_id, references(:users, type: :binary_id)
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end

    create_if_not_exists unique_index(:user_indications, [:referral_user_id, :user_id], name: :user_indications_unique_index)
  end

  def down do
    drop_if_exists table(:user_indications)
  end
end
