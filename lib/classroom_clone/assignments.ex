defmodule ClassroomClone.Assignments do
  @moduledoc """
  The Assignments context.
  """

  import Ecto.Query, warn: false
  alias ClassroomClone.Accounts.User
  alias ClassroomClone.Uploads.AssignmentDoc
  alias ClassroomClone.Repo

  alias ClassroomClone.Assignments.Assignment

  @doc """
  Returns the list of assignments.

  ## Examples

      iex> list_assignments()
      [%Assignment{}, ...]

  """
  def list_assignments do
    Repo.all(Assignment)
  end

  def get_assignments_by_class_id(class_id) do
    Assignment
    |> where([a], a.class_id == ^class_id)
    |> select([a], %{
      id: a.id,
      title: a.title
    })
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single assignment.

  Raises `Ecto.NoResultsError` if the Assignment does not exist.

  ## Examples

      iex> get_assignment!(123)
      %Assignment{}

      iex> get_assignment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_assignment!(id), do: Repo.get!(Assignment, id)

  def get_assignment(id) do
    Assignment
    |> where([a], a.id == ^id)
    |> join(:left, [a], a_doc in AssignmentDoc, on: a.id == a_doc.assignment_id)
    |> join(:inner, [a, a_doc], u in User, on: a.user_id == u.id)
    |> select([a, a_doc, u], %{
      id: a.id,
      title: a.title,
      description: a.description,
      due_date: a.due_date,
      doc_path: a_doc.file_path,
      created_at: a.inserted_at,
      teacher_id: a.user_id,
      teacher_username: u.username,
      teacher_profile: u.avatar
    })
    |> Repo.one()
  end

  @doc """
  Creates a assignment.

  ## Examples

      iex> create_assignment(%{field: value})
      {:ok, %Assignment{}}

      iex> create_assignment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_assignment(attrs \\ %{}) do
    %Assignment{}
    |> Assignment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a assignment.

  ## Examples

      iex> update_assignment(assignment, %{field: new_value})
      {:ok, %Assignment{}}

      iex> update_assignment(assignment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_assignment(%Assignment{} = assignment, attrs) do
    assignment
    |> Assignment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a assignment.

  ## Examples

      iex> delete_assignment(assignment)
      {:ok, %Assignment{}}

      iex> delete_assignment(assignment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_assignment(%Assignment{} = assignment) do
    Repo.delete(assignment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking assignment changes.

  ## Examples

      iex> change_assignment(assignment)
      %Ecto.Changeset{data: %Assignment{}}

  """
  def change_assignment(%Assignment{} = assignment, attrs \\ %{}) do
    Assignment.changeset(assignment, attrs)
  end

  alias ClassroomClone.Assignments.Submission

  @doc """
  Returns the list of submissions.

  ## Examples

      iex> list_submissions()
      [%Submission{}, ...]

  """
  def list_submissions do
    Repo.all(Submission)
  end

  @doc """
  Gets a single submission.

  Raises `Ecto.NoResultsError` if the Submission does not exist.

  ## Examples

      iex> get_submission!(123)
      %Submission{}

      iex> get_submission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_submission!(id), do: Repo.get!(Submission, id)

  def get_submission(student_id, assignment_id) do
    Submission
    |> where([s], s.assignment_id == ^assignment_id and s.user_id == ^student_id)
    |> Repo.all()
  end

  @doc """
  Creates a submission.

  ## Examples

      iex> create_submission(%{field: value})
      {:ok, %Submission{}}

      iex> create_submission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_submission(attrs \\ %{}) do
    %Submission{}
    |> Submission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a submission.

  ## Examples

      iex> update_submission(submission, %{field: new_value})
      {:ok, %Submission{}}

      iex> update_submission(submission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_submission(%Submission{} = submission, attrs) do
    submission
    |> Submission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a submission.

  ## Examples

      iex> delete_submission(submission)
      {:ok, %Submission{}}

      iex> delete_submission(submission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_submission(%Submission{} = submission) do
    Repo.delete(submission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking submission changes.

  ## Examples

      iex> change_submission(submission)
      %Ecto.Changeset{data: %Submission{}}

  """
  def change_submission(%Submission{} = submission, attrs \\ %{}) do
    Submission.changeset(submission, attrs)
  end
end
