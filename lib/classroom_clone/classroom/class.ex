defmodule ClassroomClone.Classroom.Class do
  use Ecto.Schema
  import Ecto.Changeset
  alias ClassroomClone.Accounts.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "classes" do
    field :name, :string
    field :subject, :string
    field :description, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :subject, :description, :user_id])
    |> validate_required([:name, :user_id])
  end
end
