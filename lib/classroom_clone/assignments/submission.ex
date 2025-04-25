defmodule ClassroomClone.Assignments.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "submissions" do
    belongs_to :assignment, ClassroomClone.Assignments.Assignment
    belongs_to :user, ClassroomClone.Accounts.User

    timestamps(type: :naive_datetime)
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:assignment_id, :user_id])
    |> validate_required([:assignment_id, :user_id])
  end
end
