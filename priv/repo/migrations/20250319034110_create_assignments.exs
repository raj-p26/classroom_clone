defmodule ClassroomClone.Repo.Migrations.CreateAssignments do
  use Ecto.Migration

  def change do
    create table(:assignments, primary_key: false) do
      add :id, :string, primary_key: true
      add :title, :string, null: false
      add :description, :string
      add :due_date, :date
      add :class_id, references(:classes, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:assignments, [:class_id])
  end
end
