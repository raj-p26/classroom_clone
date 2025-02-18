defmodule ClassroomClone.Classroom.Enrollment do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type Ecto.UUID
  schema "enrollments" do
    belongs_to :class, ClassroomClone.Classroom.Class
    belongs_to :user, ClassroomClone.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, [:class_id, :user_id])
    |> validate_required([:class_id, :user_id])
  end
end
