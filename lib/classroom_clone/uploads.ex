defmodule ClassroomClone.Uploads do
  @moduledoc """
  The Uploads context.
  """

  import Ecto.Query, warn: false
  alias ClassroomClone.Repo

  alias ClassroomClone.Uploads.AnnouncementDoc

  @doc """
  Returns the list of announcement_docs.

  ## Examples

      iex> list_announcement_docs()
      [%AnnouncementDoc{}, ...]

  """
  def list_announcement_docs do
    Repo.all(AnnouncementDoc)
  end

  @doc """
  Gets a single announcement_doc.

  Raises `Ecto.NoResultsError` if the Announcement doc does not exist.

  ## Examples

      iex> get_announcement_doc!(123)
      %AnnouncementDoc{}

      iex> get_announcement_doc!(456)
      ** (Ecto.NoResultsError)

  """
  def get_announcement_doc!(id), do: Repo.get!(AnnouncementDoc, id)

  @doc """
  Creates a announcement_doc.

  ## Examples

      iex> create_announcement_doc(%{field: value})
      {:ok, %AnnouncementDoc{}}

      iex> create_announcement_doc(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_announcement_doc(attrs \\ %{}) do
    %AnnouncementDoc{}
    |> AnnouncementDoc.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a announcement_doc.

  ## Examples

      iex> update_announcement_doc(announcement_doc, %{field: new_value})
      {:ok, %AnnouncementDoc{}}

      iex> update_announcement_doc(announcement_doc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_announcement_doc(%AnnouncementDoc{} = announcement_doc, attrs) do
    announcement_doc
    |> AnnouncementDoc.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a announcement_doc.

  ## Examples

      iex> delete_announcement_doc(announcement_doc)
      {:ok, %AnnouncementDoc{}}

      iex> delete_announcement_doc(announcement_doc)
      {:error, %Ecto.Changeset{}}

  """
  def delete_announcement_doc(%AnnouncementDoc{} = announcement_doc) do
    Repo.delete(announcement_doc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking announcement_doc changes.

  ## Examples

      iex> change_announcement_doc(announcement_doc)
      %Ecto.Changeset{data: %AnnouncementDoc{}}

  """
  def change_announcement_doc(%AnnouncementDoc{} = announcement_doc, attrs \\ %{}) do
    AnnouncementDoc.changeset(announcement_doc, attrs)
  end
end
