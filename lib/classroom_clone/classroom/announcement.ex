defmodule ClassroomClone.Classroom.Announcement do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type Ecto.UUID
  schema "announcements" do
    field :content, :string
    belongs_to :class, ClassroomClone.Classroom.Class
    belongs_to :user, ClassroomClone.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(announcement, attrs) do
    announcement
    |> cast(attrs, [:content, :user_id, :class_id])
    |> validate_required([:content, :user_id, :class_id])
  end
end
