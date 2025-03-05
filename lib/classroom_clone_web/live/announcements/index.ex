defmodule ClassroomCloneWeb.Announcements.Index do
  alias ClassroomClone.Uploads
  alias ClassroomClone.Classroom
  alias ClassroomCloneWeb.Hooks.VerifyClasses
  use ClassroomCloneWeb, :live_view

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

    announcement = Classroom.announcement_by_id(announcement_id)
    announcement_docs = Uploads.get_announcement_docs(announcement_id)

    trimmed_title = String.byte_slice(announcement.content, 0, 15)

    socket =
      socket
      |> assign(:class_id, class_id)
      |> assign(:announcement, announcement)
      |> assign(:docs, announcement_docs)
      |> assign(:page_title, trimmed_title <> "...")

    {:ok, socket}
  end
end
