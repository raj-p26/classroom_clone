defmodule ClassroomClone.Uploads.AnnouncementDoc do
  use Ecto.Schema
  import Ecto.Changeset

  schema "announcement_docs" do
    field :file_path, :string
    field :announcement_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(announcement_doc, attrs) do
    announcement_doc
    |> cast(attrs, [:file_path, :announcement_id])
    |> validate_required([:file_path, :announcement_id])
  end
end
