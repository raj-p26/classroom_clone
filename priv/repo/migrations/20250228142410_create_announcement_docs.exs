defmodule ClassroomClone.Repo.Migrations.CreateAnnouncementDocs do
  use Ecto.Migration

  def change do
    create table(:announcement_docs) do
      add :file_path, :string
      add :announcement_id, references(:announcements, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:announcement_docs, [:announcement_id])
  end
end
