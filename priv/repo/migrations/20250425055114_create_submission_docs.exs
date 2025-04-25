defmodule ClassroomClone.Repo.Migrations.CreateSubmissionDocs do
  use Ecto.Migration

  def change do
    create table(:submission_docs, primary_key: false) do
      add :id, :string, primary_key: true
      add :file_name, :string
      add :submission_id, references(:submissions, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:submission_docs, [:submission_id])
  end
end
