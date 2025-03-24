defmodule ClassroomClone.Uploads.AssignmentDoc do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assignment_docs" do
    field :file_path, :string
    field :assignment_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(assignment_doc, attrs) do
    assignment_doc
    |> cast(attrs, [:file_path, :assignment_id])
    |> validate_required([:file_path, :assignment_id])
  end
end
