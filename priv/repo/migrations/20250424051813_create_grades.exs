defmodule ClassroomClone.Repo.Migrations.CreateGrades do
  use Ecto.Migration

  def change do
    create table(:grades, primary_key: false) do
      add :id, :string, primary_key: true
      add :score, :decimal, default: 0
      add :submission_id, references(:submissions, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:grades, [:submission_id])
    create index(:grades, [:user_id])
  end
end
