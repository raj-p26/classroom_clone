defmodule ClassroomClone.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false
      add :subject, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:classes, [:user_id])
  end
end
