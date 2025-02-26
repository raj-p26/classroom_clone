defmodule ClassroomCloneWeb.Class.AnnouncementComponent do
  alias ClassroomClone.Classroom
  alias ClassroomClone.Classroom.Announcement
  use ClassroomCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full">
      <.simple_form for={@announcement} phx-submit="submit-announcement" phx-target={@myself}>
        <.input
          value=""
          placeholder="Announce something to your class"
          name="content"
          field={@announcement[:content]}
        />
        <button class="filled-button">Post</button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    announcement = Classroom.change_announcement(%Announcement{})

    socket =
      socket
      |> assign(assigns)
      |> assign_new(:announcement, fn -> to_form(announcement) end)

    {:ok, socket}
  end

  @impl true
  def handle_event("submit-announcement", %{"content" => content}, socket) do
    user_id = socket.assigns.user_id
    class_id = socket.assigns.class_id

    announcement_params = %{
      "content" => content,
      "user_id" => user_id,
      "class_id" => class_id
    }

    case Classroom.create_announcement(announcement_params) do
      {:ok, announcement} ->
        notify_parent(announcement.id)

        {:noreply, put_flash(socket, :info, "Announcement created")}

      {:error, changeset} ->
        {:noreply, assign(socket, :announcement, to_form(changeset))}
    end
  end

  defp notify_parent(info), do: send(self(), {__MODULE__, info})
end
