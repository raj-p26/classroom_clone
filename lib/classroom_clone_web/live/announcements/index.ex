defmodule ClassroomCloneWeb.Announcements.Index do
  alias ClassroomCloneWeb.Endpoint
  alias ClassroomClone.Comments
  alias ClassroomCloneWeb.Announcements.CommentsComponent
  alias ClassroomClone.Uploads
  alias ClassroomClone.Classroom
  alias ClassroomCloneWeb.Hooks.VerifyClasses
  use ClassroomCloneWeb, :live_view

  @comments_topic "comments"

  @impl true
  def mount(params, %{"user" => user} = session, socket) do
    %{
      "id" => class_id
    } = params

    socket = assign(socket, :user, user)

    case VerifyClasses.user_in_class?(class_id, user.id) do
      {:ok, true} ->
        init_assigns(params, session, socket)

      {:error, e} ->
        {:halt,
         socket
         |> put_flash(:error, e)
         |> push_navigate(~p"/dashboard")}
    end
  end

  defp init_assigns(params, _session, socket) do
    %{
      "id" => class_id,
      "announcement_id" => announcement_id
    } = params

    if connected?(socket) do
      Endpoint.subscribe(@comments_topic)
    end

    announcement = Classroom.announcement_by_id(announcement_id)
    announcement_docs = Uploads.get_announcement_docs(announcement_id)

    trimmed_title = String.byte_slice(announcement.content, 0, 15)

    socket =
      socket
      |> assign(:class_id, class_id)
      |> assign(:announcement, announcement)
      |> assign(:docs, announcement_docs)
      |> assign(:page_title, trimmed_title <> "...")
      |> assign(:show_create_comment_modal, false)
      |> assign_comments()

    {:ok, socket}
  end

  defp assign_comments(socket) do
    announcement_id = socket.assigns.announcement.id

    comments = Comments.get_comments_by_announcement_id(announcement_id)

    stream(socket, :comments, comments)
  end

  @impl true
  def handle_event("show-create-comment-modal", _params, socket) do
    {:noreply, update(socket, :show_create_comment_modal, fn _ -> true end)}
  end

  @impl true
  def handle_event("hide-create-comment-modal", _params, socket) do
    {:noreply, update(socket, :show_create_comment_modal, fn _ -> false end)}
  end

  @impl true
  def handle_info(:created, socket) do
    socket =
      socket
      |> update(:show_create_comment_modal, fn _ -> false end)
      |> put_flash(:info, "Comment Posted")

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "comment-created", payload: comment_id}, socket) do
    comment = Comments.get_comment(comment_id)
    {:noreply, stream_insert(socket, :comments, comment, at: 0)}
  end

  defp show_comment(assigns) do
    ~H"""
    <div class="border border-outline/30 dark:border-outline-dark/30 rounded-lg p-4 my-2" id={@id}>
      <div class="flex items-center gap-4 px-4">
        <img src={@comment.user_avatar} class="rounded-full size-12" />
        <div>
          <p>{@comment.username}</p>
          <p class="text-sm font-light">
            {Calendar.strftime(@comment.commented_at, "%B %d, %Y [%I:%M %p]")}
          </p>
        </div>
      </div>
      <hr class="my-2 border-outline dark:border-outline-dark opacity-30" />
      <h1 class="text-lg">{@comment.content}</h1>
    </div>
    """
  end
end
