defmodule ClassroomClone.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements) do
      add :content, :string
      add :class_id, references(:classes, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:announcements, [:class_id])
    create index(:announcements, [:user_id])
  end
end
