defmodule ClassroomClone.Classroom do
  @moduledoc """
  The Classroom context.
  """

  import Ecto.Query, warn: false
  alias ClassroomClone.Accounts.User
  alias ClassroomClone.Repo

  alias ClassroomClone.Classroom.Class

  @doc """
  Returns the list of classes.

  ## Examples

      iex> list_classes()
      [%Class{}, ...]

  """
  def list_classes do
    Repo.all(Class)
  end

  @doc """
  Gets a single class.

  Raises `Ecto.NoResultsError` if the Class does not exist.

  ## Examples

      iex> get_class!(123)
      %Class{}

      iex> get_class!(456)
      ** (Ecto.NoResultsError)

  """
  def get_class!(id), do: Repo.get!(Class, id)

  def get_class(id) do
    Repo.get(Class, id)
  end

  @doc """
  Creates a class.

  ## Examples

      iex> create_class(%{field: value})
      {:ok, %Class{}}

      iex> create_class(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_class(attrs \\ %{}) do
    %Class{}
    |> Class.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a class.

  ## Examples

      iex> update_class(class, %{field: new_value})
      {:ok, %Class{}}

      iex> update_class(class, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_class(%Class{} = class, attrs) do
    class
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a class.

  ## Examples

      iex> delete_class(class)
      {:ok, %Class{}}

      iex> delete_class(class)
      {:error, %Ecto.Changeset{}}

  """
  def delete_class(%Class{} = class) do
    Repo.delete(class)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking class changes.

  ## Examples

      iex> change_class(class)
      %Ecto.Changeset{data: %Class{}}

  """
  def change_class(%Class{} = class, attrs \\ %{}) do
    Class.changeset(class, attrs)
  end

  alias ClassroomClone.Classroom.Enrollment

  @doc """
  Returns the list of enrollments.

  ## Examples

      iex> list_enrollments()
      [%Enrollment{}, ...]

  """
  def list_enrollments do
    Repo.all(Enrollment)
  end

  def list_class_enrollments(class_id) do
    Enrollment
    |> where([e], e.class_id == ^class_id)
    |> join(:inner, [e], u in User, on: e.user_id == u.id)
    |> select([e, u], %{
      id: e.id,
      user_avatar: u.avatar,
      username: u.username
    })
    |> Repo.all()
  end

  @doc """
  Gets a single enrollment.

  Raises `Ecto.NoResultsError` if the Enrollment does not exist.

  ## Examples

      iex> get_enrollment!(123)
      %Enrollment{}

      iex> get_enrollment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_enrollment!(id), do: Repo.get!(Enrollment, id)

  @doc """
  Creates a enrollment.

  ## Examples

      iex> create_enrollment(%{field: value})
      {:ok, %Enrollment{}}

      iex> create_enrollment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_enrollment(attrs \\ %{}) do
    %Enrollment{}
    |> Enrollment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a enrollment.

  ## Examples

      iex> update_enrollment(enrollment, %{field: new_value})
      {:ok, %Enrollment{}}

      iex> update_enrollment(enrollment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_enrollment(%Enrollment{} = enrollment, attrs) do
    enrollment
    |> Enrollment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a enrollment.

  ## Examples

      iex> delete_enrollment(enrollment)
      {:ok, %Enrollment{}}

      iex> delete_enrollment(enrollment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_enrollment(%Enrollment{} = enrollment) do
    Repo.delete(enrollment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking enrollment changes.

  ## Examples

      iex> change_enrollment(enrollment)
      %Ecto.Changeset{data: %Enrollment{}}

  """
  def change_enrollment(%Enrollment{} = enrollment, attrs \\ %{}) do
    Enrollment.changeset(enrollment, attrs)
  end

  def class_by_user(user_id) do
    Class
    |> where([c], c.user_id == ^user_id)
    |> join(:left, [c], u in User, on: u.id == c.user_id)
    |> select([c, u], %{
      id: c.id,
      name: c.name,
      subject: c.subject,
      owner: u.username
    })
    |> Repo.all()
  end

  def enrollments_by_user(user_id) do
    Enrollment
    |> where([e], e.user_id == ^user_id)
    |> Repo.all()
  end

  def enrolled_classes_by_user(user_id) do
    Enrollment
    |> where([e], e.user_id == ^user_id)
    |> join(:left, [e], c in Class, on: c.id == e.class_id)
    |> join(:inner, [e, c], u in User, on: c.user_id == u.id)
    |> select([e, c, u], %{
      id: c.id,
      owner: u.username,
      name: c.name,
      subject: c.subject,
      owner_avatar: u.avatar
    })
    |> Repo.all()
  end

  def get_class_by_join_code(join_code) do
    try do
      Class
      |> where([c], c.id == ^join_code)
      |> Repo.one()
    rescue
      _ -> nil
    end
  end

  def check_if_user_exists(join_code, user_id) do
    try do
      class_owner =
        Class
        |> where([c], c.user_id == ^user_id and c.id == ^join_code)
        |> Repo.one()

      if class_owner != nil, do: raise("You are the owner of the class")

      record =
        Enrollment
        |> where([e], e.class_id == ^join_code and e.user_id == ^user_id)
        |> Repo.one()

      if record != nil, do: raise("Already Joined")
      {:ok, nil}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  alias ClassroomClone.Classroom.Announcement

  @doc """
  Returns the list of announcements.

  ## Examples

      iex> list_announcements()
      [%Announcement{}, ...]

  """
  def list_announcements do
    Repo.all(Announcement)
  end

  @doc """
  Gets a single announcement.

  Raises `Ecto.NoResultsError` if the Announcement does not exist.

  ## Examples

      iex> get_announcement!(123)
      %Announcement{}

      iex> get_announcement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_announcement!(id), do: Repo.get!(Announcement, id)

  @doc """
  Creates a announcement.

  ## Examples

      iex> create_announcement(%{field: value})
      {:ok, %Announcement{}}

      iex> create_announcement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_announcement(attrs \\ %{}) do
    %Announcement{}
    |> Announcement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a announcement.

  ## Examples

      iex> update_announcement(announcement, %{field: new_value})
      {:ok, %Announcement{}}

      iex> update_announcement(announcement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_announcement(%Announcement{} = announcement, attrs) do
    announcement
    |> Announcement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a announcement.

  ## Examples

      iex> delete_announcement(announcement)
      {:ok, %Announcement{}}

      iex> delete_announcement(announcement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_announcement(%Announcement{} = announcement) do
    Repo.delete(announcement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking announcement changes.

  ## Examples

      iex> change_announcement(announcement)
      %Ecto.Changeset{data: %Announcement{}}

  """
  def change_announcement(%Announcement{} = announcement, attrs \\ %{}) do
    Announcement.changeset(announcement, attrs)
  end

  def announcements_by_class_id(class_id) do
    Announcement
    |> where([a], a.class_id == ^class_id)
    |> join(:inner, [a], u in User, on: a.user_id == u.id)
    |> select([a, u], %{
      id: a.id,
      announcer_avatar: u.avatar,
      announcer_name: u.username,
      announced_at: a.inserted_at,
      content: a.content
    })
    |> order_by([a, u], desc: a.inserted_at)
    |> Repo.all()
  end

  def announcement_by_id(id) do
    Announcement
    |> where([a], a.id == ^id)
    |> join(:inner, [a], u in User, on: a.user_id == u.id)
    |> select([a, u], %{
      id: a.id,
      announcer_avatar: u.avatar,
      announcer_name: u.username,
      announced_at: a.inserted_at,
      content: a.content
    })
    |> Repo.one()
  end
end
