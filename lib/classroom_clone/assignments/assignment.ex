defmodule ClassroomClone.Assignments.Assignment do
  use Ecto.Schema
  import Ecto.Changeset

  alias ClassroomClone.Classroom.Class

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "assignments" do
    field :description, :string
    field :title, :string
    field :due_date, :date
    belongs_to :class, Class

    timestamps()
  end

  @doc false
  def changeset(assignment, attrs) do
    assignment
    |> cast(attrs, [:title, :description, :due_date, :class_id])
    |> validate_required([:title, :class_id])
  end
end
