defmodule ClassroomClone.Assignments.Grade do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "grades" do
    field :score, :decimal
    field :submission_id, :string
    field :user_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(grade, attrs) do
    grade
    |> cast(attrs, [:score, :submission_id, :user_id])
    |> validate_required([:score, :submission_id, :user_id])
    |> validate_number(:score, greater_than_or_equal_to: 0, message: "Grades cannot be negative")
  end
end
