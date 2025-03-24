defmodule ClassroomClone.Repo.Migrations.CreateAssignmentComments do
  use Ecto.Migration

  def change do
    create table(:assignment_comments) do
      add :content, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :assignment_id, references(:assignments, on_delete: :delete_all)

      timestamps()
    end

    create index(:assignment_comments, [:user_id])
    create index(:assignment_comments, [:assignment_id])
  end
end
