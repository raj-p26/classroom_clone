defmodule ClassroomClone.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias ClassroomClone.Accounts.User
  alias ClassroomClone.Repo

  alias ClassroomClone.Comments.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  def get_comment(id) do
    Comment
    |> where([c], c.id == ^id)
    |> join(:inner, [c], u in User, on: c.user_id == u.id)
    |> select([c, u], %{
      id: c.id,
      username: u.username,
      user_avatar: u.avatar,
      content: c.content,
      commented_at: c.inserted_at
    })
    |> Repo.one()
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  def get_comments_by_announcement_id(announcement_id) do
    Comment
    |> where([c], c.announcement_id == ^announcement_id)
    |> join(:inner, [c], u in User, on: c.user_id == u.id)
    |> select([c, u], %{
      id: c.id,
      content: c.content,
      username: u.username,
      user_avatar: u.avatar,
      commented_at: c.inserted_at
    })
    |> order_by([c, u], desc: c.inserted_at)
    |> Repo.all()
  end

  alias ClassroomClone.Comments.AssignmentComment

  @doc """
  Returns the list of assignment_comments.

  ## Examples

      iex> list_assignment_comments()
      [%AssignmentComment{}, ...]

  """
  def list_assignment_comments do
    Repo.all(AssignmentComment)
  end

  def list_assignment_comments(assignment_id) do
    AssignmentComment
    |> where([ac], ac.assignment_id == ^assignment_id)
    |> join(:inner, [ac], u in User, on: ac.user_id == u.id)
    |> select([ac, u], %{
      id: ac.id,
      content: ac.content,
      username: u.username,
      user_avatar: u.avatar,
      commented_at: ac.inserted_at
    })
    |> order_by([ac, u], desc: ac.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single assignment_comment.

  Raises `Ecto.NoResultsError` if the Assignment comment does not exist.

  ## Examples

      iex> get_assignment_comment!(123)
      %AssignmentComment{}

      iex> get_assignment_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_assignment_comment!(id), do: Repo.get!(AssignmentComment, id)

  def get_assignment_comment(id) do
    AssignmentComment
    |> where([ac], ac.id == ^id)
    |> join(:inner, [ac], u in User, on: ac.user_id == u.id)
    |> select([ac, u], %{
      id: ac.id,
      username: u.username,
      user_avatar: u.avatar,
      content: ac.content,
      commented_at: ac.inserted_at
    })
    |> Repo.one()
  end

  @doc """
  Creates a assignment_comment.

  ## Examples

      iex> create_assignment_comment(%{field: value})
      {:ok, %AssignmentComment{}}

      iex> create_assignment_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_assignment_comment(attrs \\ %{}) do
    %AssignmentComment{}
    |> AssignmentComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a assignment_comment.

  ## Examples

      iex> update_assignment_comment(assignment_comment, %{field: new_value})
      {:ok, %AssignmentComment{}}

      iex> update_assignment_comment(assignment_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_assignment_comment(%AssignmentComment{} = assignment_comment, attrs) do
    assignment_comment
    |> AssignmentComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a assignment_comment.

  ## Examples

      iex> delete_assignment_comment(assignment_comment)
      {:ok, %AssignmentComment{}}

      iex> delete_assignment_comment(assignment_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_assignment_comment(%AssignmentComment{} = assignment_comment) do
    Repo.delete(assignment_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking assignment_comment changes.

  ## Examples

      iex> change_assignment_comment(assignment_comment)
      %Ecto.Changeset{data: %AssignmentComment{}}

  """
  def change_assignment_comment(%AssignmentComment{} = assignment_comment, attrs \\ %{}) do
    AssignmentComment.changeset(assignment_comment, attrs)
  end
end
