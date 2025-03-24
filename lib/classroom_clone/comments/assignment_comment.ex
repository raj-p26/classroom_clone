defmodule ClassroomClone.Comments.AssignmentComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assignment_comments" do
    field :content, :string
    field :user_id, :string
    field :assignment_id, :string

    timestamps()
  end

  @doc false
  def changeset(assignment_comment, attrs) do
    assignment_comment
    |> cast(attrs, [:content, :user_id, :assignment_id])
    |> validate_required([:content, :user_id, :assignment_id])
  end
end
