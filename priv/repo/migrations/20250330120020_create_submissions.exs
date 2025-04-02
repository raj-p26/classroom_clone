defmodule ClassroomClone.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :file_name, :string
      add :assignment_id, references(:assignments, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :naive_datetime)
    end

    create index(:submissions, [:assignment_id])
    create index(:submissions, [:user_id])
  end
end
