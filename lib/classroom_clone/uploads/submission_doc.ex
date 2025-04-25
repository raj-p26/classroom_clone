defmodule ClassroomClone.Uploads.SubmissionDoc do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "submission_docs" do
    field :file_name, :string
    belongs_to :submission, ClassroomClone.Assignments.Submission

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(submission_doc, attrs) do
    submission_doc
    |> cast(attrs, [:file_name, :submission_id])
    |> validate_required([:file_name, :submission_id])
  end
end
