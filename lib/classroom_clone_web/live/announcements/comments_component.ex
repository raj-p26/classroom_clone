defmodule ClassroomCloneWeb.Announcements.CommentsComponent do
  alias ClassroomCloneWeb.Endpoint
  alias ClassroomClone.Comments.Comment
  alias ClassroomClone.Comments
  use ClassroomCloneWeb, :live_component

  @comments_topic "comments"

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>Make a comment</.header>
      <.simple_form for={@comment} phx-submit="create-comment" phx-target={@myself}>
        <.input
          type="textarea"
          name="content"
          field={@comment[:content]}
          value=""
          placeholder="Add class comment..."
        />
        <button class="filled-button">Post</button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    comment = Comments.change_comment(%Comment{})

    socket =
      socket
      |> assign(assigns)
      |> assign_new(:comment, fn -> to_form(comment) end)

    {:ok, socket}
  end

  @impl true
  def handle_event("create-comment", params, socket) do
    params =
      params
      |> Map.put("user_id", socket.assigns.user_id)
      |> Map.put("announcement_id", socket.assigns.announcement_id)

    case Comments.create_comment(params) do
      {:ok, comment} ->
        Endpoint.broadcast(@comments_topic, "comment-created", comment.id)
        notify_parent(:created)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :comment, to_form(changeset))}
    end
  end

  defp notify_parent(info), do: send(self(), info)
end
