defmodule ClassroomCloneWeb.Class.Index do
  alias ClassroomClone.Assignments
  alias ClassroomClone.Accounts
  alias ClassroomCloneWeb.Endpoint
  alias ClassroomCloneWeb.Class.AnnouncementComponent
  alias ClassroomCloneWeb.Class.AssignmentFormComponent
  alias ClassroomClone.Classroom

  use ClassroomCloneWeb, :live_view

  @announcements_topic "announcements"
  @assignments_topic "assignments"

  @impl true
  def mount(params, %{"user" => user}, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@announcements_topic)
      Endpoint.subscribe(@assignments_topic)
    end

    socket =
      socket
      |> assign(:user, user)
      |> assign_class(params["id"])
      |> assign_enrollments
      |> assign_live_title
      |> assign_announcements
      |> assign_is_class_owner
      |> assign_assignments
      |> assign(:make_announcement, false)
      |> assign(:create_assignment, false)

    {:ok, socket}
  end

  defp assign_class(socket, class_id) do
    class = Classroom.get_class(class_id)

    assign_new(socket, :class, fn -> class end)
  end

  defp assign_enrollments(socket) do
    enrollments = Classroom.list_class_enrollments(socket.assigns.class.id)

    assign_new(socket, :enrollments, fn -> enrollments end)
  end

  defp assign_live_title(socket) do
    class = socket.assigns.class

    assign(socket, :page_title, "#{class.name} #{class.subject}")
  end

  defp assign_announcements(socket) do
    class_id = socket.assigns.class.id
    announcements = Classroom.announcements_by_class_id(class_id)

    assign(socket, :announcements, announcements)
  end

  defp assign_is_class_owner(socket) do
    class = socket.assigns.class
    user = socket.assigns.user

    assign(socket, :is_class_owner, class.user_id == user.id)
  end

  defp assign_assignments(socket) do
    class_id = socket.assigns.class.id

    assignments = Assignments.get_assignments_by_class_id(class_id)
    assign(socket, :assignments, assignments)
  end

  @impl true
  def handle_params(_params, _uri, socket), do: {:noreply, socket}

  @impl true
  def handle_event("create-asgmt", _params, socket) do
    {:noreply, update(socket, :create_assignment, fn _ -> true end)}
  end

  @impl true
  def handle_event("hide-create-assignment", _params, socket) do
    {:noreply, update(socket, :create_assignment, fn _ -> false end)}
  end

  @impl true
  def handle_event("close-announcement-modal", _params, socket) do
    socket = update(socket, :make_announcement, fn _prev_state -> false end)
    {:noreply, socket}
  end

  @impl true
  def handle_event("open-announcement-modal", _params, socket) do
    socket = update(socket, :make_announcement, fn _prev_state -> true end)
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete-announcement", %{"id" => id}, socket) do
    result = Classroom.delete_announcement_by_id(id)

    delete_announcement(socket, id, result)
  end

  defp delete_announcement(socket, id, {:ok, _}) do
    Endpoint.broadcast(@announcements_topic, "announcement_deleted", id)

    {:noreply, put_flash(socket, :info, "Announcement deleted")}
  end

  defp delete_announcement(socket, _, {:error, _}) do
    {:noreply, put_flash(socket, :error, "Unable to delete flash")}
  end

  @impl true
  def handle_info(
        %{event: "announcement_created", payload: announcement_id},
        socket
      ) do
    announcement = Classroom.announcement_by_id(announcement_id)

    {:noreply, update(socket, :announcements, &[announcement | &1])}
  end

  @impl true
  def handle_info(%{event: "announcement_deleted"} = info, socket) do
    %{payload: id} = info
    old_announcements = socket.assigns.announcements

    new_announcements =
      Enum.filter(old_announcements, fn announcement ->
        announcement.id !== id
      end)

    {:noreply, update(socket, :announcements, fn _ -> new_announcements end)}
  end

  def handle_info({AnnouncementComponent, :created}, socket) do
    socket =
      socket
      |> put_flash(:info, "Post Created")
      |> update(:make_announcement, fn _ -> false end)

    {:noreply, put_flash(socket, :info, "Post created")}
  end

  def handle_info(%{event: "enrolled", payload: user_id}, socket) do
    enrollments = socket.assigns.enrollments
    user = Accounts.get_user_details(user_id)

    {:noreply, assign(socket, :enrollments, enrollments ++ [user])}
  end

  def handle_info({AssignmentFormComponent, :created}, socket) do
    socket =
      socket
      |> update(:create_assignment, fn _ -> false end)
      |> put_flash(:info, "Assignment Created")

    {:noreply, socket}
  end

  def handle_info(%{event: "assignment-created"} = info, socket) do
    %{payload: asgmt_id} = info
    assignment = Assignments.get_assignment(asgmt_id)

    {:noreply, update(socket, :assignments, &[assignment | &1])}
  end

  defp show_announcement(assigns) do
    ~H"""
    <div
      class="border border-outline/30 dark:border-outline-dark/30 rounded-lg p-4 my-2"
      id={"announcement-#{@id}"}
      phx-remove={hide("#announcement-#{@id}")}
    >
      <div class="flex items-center gap-4 relative">
        <img src={@announcer_avatar} class="size-10 rounded-full" aria-hidden="true" />
        <div>
          <p class="text-lg">{@announcer_name}</p>
          <p class="text-sm font-light">{Calendar.strftime(@announced_at, "%B %d, %Y [%I:%M %p]")}</p>
        </div>
      </div>
      <p class="mt-2">{@content}</p>
      <p>Attached documents: {@document_count}</p>
      <div class="flex items-center gap-4 mt-4">
        <button class="text-button" phx-click={JS.patch(~p"/c/#{@class_id}/a/#{@id}")}>
          View
        </button>
        <button
          :if={@is_class_owner}
          id={"delete-#{@id}-btn"}
          phx-hook="RippleEffect"
          class="text-button-error"
          phx-click={
            JS.push("delete-announcement", value: %{id: @id})
            |> hide("#announcement-#{@id}")
          }
        >
          Delete
        </button>
      </div>
    </div>
    """
  end
end
