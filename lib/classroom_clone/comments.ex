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
end
