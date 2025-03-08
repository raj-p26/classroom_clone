defmodule ClassroomClone.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :announcement_id, references(:announcements, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:user_id])
    create index(:comments, [:announcement_id])
  end
end
