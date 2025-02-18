defmodule ClassroomClone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true
      add :google_id, :string
      add :username, :string
      add :email, :string
      add :avatar, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:google_id])
  end
end
