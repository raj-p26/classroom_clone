defmodule ClassroomClone.Repo.Migrations.CreateAssignmentDocs do
  use Ecto.Migration

  def change do
    create table(:assignment_docs) do
      add :file_path, :string
      add :assignment_id, references(:assignments, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:assignment_docs, [:assignment_id])
  end
end
