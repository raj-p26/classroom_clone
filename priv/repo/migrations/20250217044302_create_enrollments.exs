defmodule ClassroomClone.Repo.Migrations.CreateEnrollments do
  use Ecto.Migration

  def change do
    create table(:enrollments) do
      add :class_id, references(:classes, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:enrollments, [:class_id])
    create index(:enrollments, [:user_id])
  end
end
