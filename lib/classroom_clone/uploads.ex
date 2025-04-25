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

  def get_announcement_docs_count(announcement_id) do
    AnnouncementDoc
    |> where([a], a.announcement_id == ^announcement_id)
    |> select([a], count("*"))
    |> Repo.one()
  end

  def get_announcement_docs(announcement_id) do
    AnnouncementDoc
    |> where([a], a.announcement_id == ^announcement_id)
    |> Repo.all()
  end

  alias ClassroomClone.Uploads.AssignmentDoc

  @doc """
  Returns the list of assignment_docs.

  ## Examples

      iex> list_assignment_docs()
      [%AssignmentDoc{}, ...]

  """
  def list_assignment_docs do
    Repo.all(AssignmentDoc)
  end

  @doc """
  Gets a single assignment_doc.

  Raises `Ecto.NoResultsError` if the Assignment doc does not exist.

  ## Examples

      iex> get_assignment_doc!(123)
      %AssignmentDoc{}

      iex> get_assignment_doc!(456)
      ** (Ecto.NoResultsError)

  """
  def get_assignment_doc!(id), do: Repo.get!(AssignmentDoc, id)

  @doc """
  Creates a assignment_doc.

  ## Examples

      iex> create_assignment_doc(%{field: value})
      {:ok, %AssignmentDoc{}}

      iex> create_assignment_doc(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_assignment_doc(attrs \\ %{}) do
    %AssignmentDoc{}
    |> AssignmentDoc.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a assignment_doc.

  ## Examples

      iex> update_assignment_doc(assignment_doc, %{field: new_value})
      {:ok, %AssignmentDoc{}}

      iex> update_assignment_doc(assignment_doc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_assignment_doc(%AssignmentDoc{} = assignment_doc, attrs) do
    assignment_doc
    |> AssignmentDoc.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a assignment_doc.

  ## Examples

      iex> delete_assignment_doc(assignment_doc)
      {:ok, %AssignmentDoc{}}

      iex> delete_assignment_doc(assignment_doc)
      {:error, %Ecto.Changeset{}}

  """
  def delete_assignment_doc(%AssignmentDoc{} = assignment_doc) do
    Repo.delete(assignment_doc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking assignment_doc changes.

  ## Examples

      iex> change_assignment_doc(assignment_doc)
      %Ecto.Changeset{data: %AssignmentDoc{}}

  """
  def change_assignment_doc(%AssignmentDoc{} = assignment_doc, attrs \\ %{}) do
    AssignmentDoc.changeset(assignment_doc, attrs)
  end

  alias ClassroomClone.Uploads.SubmissionDoc

  @doc """
  Returns the list of submission_docs.

  ## Examples

      iex> list_submission_docs()
      [%SubmissionDoc{}, ...]

  """
  def list_submission_docs do
    Repo.all(SubmissionDoc)
  end

  def list_submission_docs_by_id(submission_id) do
    SubmissionDoc
    |> where([s], s.submission_id == ^submission_id)
    |> Repo.all()
  end

  @doc """
  Gets a single submission_doc.

  Raises `Ecto.NoResultsError` if the Submission doc does not exist.

  ## Examples

      iex> get_submission_doc!(123)
      %SubmissionDoc{}

      iex> get_submission_doc!(456)
      ** (Ecto.NoResultsError)

  """
  def get_submission_doc!(id), do: Repo.get!(SubmissionDoc, id)

  @doc """
  Creates a submission_doc.

  ## Examples

      iex> create_submission_doc(%{field: value})
      {:ok, %SubmissionDoc{}}

      iex> create_submission_doc(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_submission_doc(attrs \\ %{}) do
    %SubmissionDoc{}
    |> SubmissionDoc.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a submission_doc.

  ## Examples

      iex> update_submission_doc(submission_doc, %{field: new_value})
      {:ok, %SubmissionDoc{}}

      iex> update_submission_doc(submission_doc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_submission_doc(%SubmissionDoc{} = submission_doc, attrs) do
    submission_doc
    |> SubmissionDoc.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a submission_doc.

  ## Examples

      iex> delete_submission_doc(submission_doc)
      {:ok, %SubmissionDoc{}}

      iex> delete_submission_doc(submission_doc)
      {:error, %Ecto.Changeset{}}

  """
  def delete_submission_doc(%SubmissionDoc{} = submission_doc) do
    Repo.delete(submission_doc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking submission_doc changes.

  ## Examples

      iex> change_submission_doc(submission_doc)
      %Ecto.Changeset{data: %SubmissionDoc{}}

  """
  def change_submission_doc(%SubmissionDoc{} = submission_doc, attrs \\ %{}) do
    SubmissionDoc.changeset(submission_doc, attrs)
  end
end
