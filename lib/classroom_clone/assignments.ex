defmodule ClassroomClone.Assignments do
  @moduledoc """
  The Assignments context.
  """

  import Ecto.Query, warn: false
  alias ClassroomClone.Uploads.SubmissionDoc
  alias ClassroomClone.Assignments.Grade
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
  def get_assignment_by_id(id), do: Repo.get(Assignment, id)

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

  def list_submissions_by_assignment_id(assignment_id) do
    Submission
    |> where([s], s.assignment_id == ^assignment_id)
    |> join(:left, [s], u in User, on: s.user_id == u.id)
    |> join(:left, [s, u], g in Grade, on: s.id == g.submission_id)
    |> join(:left, [s, u, g], sd in SubmissionDoc, on: s.id == sd.submission_id)
    |> join(:inner, [s, u, g, sd], a in Assignment, on: s.assignment_id == a.id)
    |> group_by([s, u, g, sd, a], u.id)
    |> select([s, u, g, sd, a], %{
      id: s.id,
      user_id: u.id,
      user_avatar: u.avatar,
      username: u.username,
      attached_docs_count: count(sd.id),
      grade_id: g.id,
      grades: g.score,
      assignment_due_date: a.due_date,
      submitted_at: s.inserted_at
    })
    |> Repo.all()
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
    |> Repo.one()
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

  alias ClassroomClone.Assignments.Grade

  @doc """
  Returns the list of grades.

  ## Examples

      iex> list_grades()
      [%Grade{}, ...]

  """
  def list_grades do
    Repo.all(Grade)
  end

  @doc """
  Gets a single grade.

  Raises `Ecto.NoResultsError` if the Grade does not exist.

  ## Examples

      iex> get_grade!(123)
      %Grade{}

      iex> get_grade!(456)
      ** (Ecto.NoResultsError)

  """
  def get_grade!(id), do: Repo.get!(Grade, id)

  @doc """
  Creates a grade.

  ## Examples

      iex> create_grade(%{field: value})
      {:ok, %Grade{}}

      iex> create_grade(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_grade(attrs \\ %{}) do
    %Grade{}
    |> Grade.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a grade.

  ## Examples

      iex> update_grade(grade, %{field: new_value})
      {:ok, %Grade{}}

      iex> update_grade(grade, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_grade(%Grade{} = grade, attrs) do
    grade
    |> Grade.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a grade.

  ## Examples

      iex> delete_grade(grade)
      {:ok, %Grade{}}

      iex> delete_grade(grade)
      {:error, %Ecto.Changeset{}}

  """
  def delete_grade(%Grade{} = grade) do
    Repo.delete(grade)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking grade changes.

  ## Examples

      iex> change_grade(grade)
      %Ecto.Changeset{data: %Grade{}}

  """
  def change_grade(%Grade{} = grade, attrs \\ %{}) do
    Grade.changeset(grade, attrs)
  end
end
