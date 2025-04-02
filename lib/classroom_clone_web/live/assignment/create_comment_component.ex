defmodule ClassroomCloneWeb.Assignment.CreateCommentComponent do
  alias ClassroomCloneWeb.Endpoint
  alias ClassroomClone.Comments.AssignmentComment
  alias ClassroomClone.Comments
  use ClassroomCloneWeb, :live_component

  @assignment_comments_topic "assignment comments"

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@comment} phx-submit="create-comment" phx-target={@myself}>
        <.input field={@comment[:content]} type="textarea" placeholder="Add a comment" />
        <:actions>
          <button class="filled-button" phx-disable-with="posting...">
            Post
          </button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:comment, fn -> to_form(change_comment()) end)

    {:ok, socket}
  end

  defp change_comment(attrs \\ %{}) do
    Comments.change_assignment_comment(%AssignmentComment{}, attrs)
  end

  @impl true
  def handle_event("create-comment", %{"assignment_comment" => comment_params}, socket) do
    asgmt_id = socket.assigns.assignment_id
    user_id = socket.assigns.user_id

    comment_params =
      comment_params
      |> Map.put("assignment_id", asgmt_id)
      |> Map.put("user_id", user_id)

    socket =
      case Comments.create_assignment_comment(comment_params) do
        {:ok, comment} ->
          Endpoint.broadcast(@assignment_comments_topic, "comment-created", comment.id)
          notify_parent(:created)

          socket
          |> update(:comment, fn _ ->
            to_form(change_comment(%{comment_params | "content" => ""}))
          end)
          |> put_flash(:info, "Comment posted.")

        {:error, changeset} ->
          assign(socket, :comment, to_form(changeset))
      end

    {:noreply, socket}
  end

  defp notify_parent(info), do: send(self(), {__MODULE__, info})
end
