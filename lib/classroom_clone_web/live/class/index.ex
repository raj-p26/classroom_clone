defmodule ClassroomCloneWeb.Class.Index do
  alias ClassroomClone.Uploads
  alias ClassroomClone.Accounts
  alias ClassroomCloneWeb.Endpoint
  alias ClassroomCloneWeb.Class.AnnouncementComponent
  alias ClassroomClone.Classroom

  use ClassroomCloneWeb, :live_view

  @announcements_topic "announcements"

  @impl true
  def mount(params, %{"user" => user}, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@announcements_topic)
    end

    socket =
      socket
      |> assign(:user, user)
      |> assign_class(params["id"])
      |> assign_enrollments
      |> assign_live_title
      |> assign_announcements
      |> assign(:make_announcement, false)

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

  @impl true
  def handle_params(_params, _uri, socket), do: {:noreply, socket}

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
  def handle_info(
        %{event: "announcement_created", payload: announcement_id},
        socket
      ) do
    announcement = Classroom.announcement_by_id(announcement_id)

    socket = update(socket, :make_announcement, fn _prev_state -> false end)

    {:noreply, update(socket, :announcements, &[announcement | &1])}
  end

  def handle_info({AnnouncementComponent, :created}, socket) do
    {:noreply, put_flash(socket, :info, "Post created")}
  end

  def handle_info(%{event: "enrolled", payload: user_id}, socket) do
    enrollments = socket.assigns.enrollments
    user = Accounts.get_user_details(user_id)

    {:noreply, assign(socket, :enrollments, enrollments ++ [user])}
  end

  defp show_announcement(assigns) do
    ~H"""
    <div class="border border-outline/30 dark:border-outline-dark/30 rounded-lg p-4 my-2">
      <div class="flex items-center gap-4">
        <img src={@announcer_avatar} class="size-10 rounded-full" aria-hidden="true" />
        <div>
          <p class="text-lg">{@announcer_name}</p>
          <p class="text-sm font-light">{Calendar.strftime(@announced_at, "%B %d, %Y [%I:%M %p]")}</p>
        </div>
      </div>
      <p class="mt-2">{@content}</p>
      <p>Attached documents: {get_document_count(@id)}</p>
    </div>
    """
  end

  defp get_document_count(announcement_id) do
    Uploads.get_announcement_docs_count(announcement_id)
  end
end
