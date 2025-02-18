defmodule ClassroomClone.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field :google_id, :string
    field :username, :string
    field :email, :string
    field :avatar, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:google_id, :username, :email, :avatar])
    |> validate_required([:google_id, :username, :email, :avatar])
    |> unique_constraint(:email)
    |> unique_constraint(:google_id)
  end
end
