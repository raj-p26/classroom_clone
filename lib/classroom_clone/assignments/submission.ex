defmodule ClassroomClone.Assignments.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type Ecto.UUID
  schema "submissions" do
    field :file_name, :string
    belongs_to :assignment, ClassroomClone.Assignments.Assignment
    belongs_to :user, ClassroomClone.Accounts.User

    timestamps(type: :naive_datetime)
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:file_name, :assignment_id, :user_id])
    |> validate_required([:file_name, :assignment_id, :user_id])
  end
end
