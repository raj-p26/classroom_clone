defmodule ClassroomClone.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :user_id, :string
    field :announcement_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :user_id, :announcement_id])
    |> validate_required([:content, :user_id, :announcement_id])
  end
end
