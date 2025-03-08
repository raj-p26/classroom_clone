defmodule ClassroomCloneWeb.Class.AnnouncementComponent do
  alias ClassroomClone.Uploads
  alias ClassroomClone.Classroom
  alias ClassroomClone.Classroom.Announcement
  alias ClassroomCloneWeb.Endpoint

  use ClassroomCloneWeb, :live_component

  @announcements_topic "announcements"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full">
      <.header>Announce something to your class</.header>
      <.simple_form
        for={@announcement}
        phx-submit="submit-announcement"
        phx-change="validate"
        phx-target={@myself}
      >
        <.input value="" placeholder="Announcement" name="content" field={@announcement[:content]} />
        <div
          phx-drop-target={@uploads.announcement_docs.ref}
          class="border border-dashed rounded-xl py-20"
        >
          <.live_file_input upload={@uploads.announcement_docs} class="hidden" />
          <label
            class="outlined-button mx-auto cursor-pointer"
            id="upload-files-button"
            phx-hook="RippleEffect"
            for={@uploads.announcement_docs.ref}
          >
            Browse
          </label>
          <p class="w-fit mx-auto">or drag files here</p>
        </div>
        <button class="filled-button ml-auto">Post</button>
      </.simple_form>
      <p :for={err <- upload_errors(@uploads.announcement_docs)} class="text-error">
        {error_to_string(err)}
      </p>
      <div :for={entry <- @uploads.announcement_docs.entries}>
        {entry.client_name}
      </div>
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
      |> allow_upload(:announcement_docs,
        accept: ~w(.jpg .mp4 .png .jpeg .zip .docx .pptx .xlsx .csv),
        max_entries: 5
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _params, socket), do: {:noreply, socket}

  @impl true
  def handle_event("submit-announcement", %{"content" => content}, socket) do
    user_id = socket.assigns.user_id
    class_id = socket.assigns.class_id

    announcement_params = %{
      "content" => content,
      "user_id" => user_id,
      "class_id" => class_id
    }

    result = Classroom.create_announcement(announcement_params)

    create_announcement_handler(result, socket)
  end

  defp create_announcement_handler({:ok, announcement}, socket) do
    _ =
      consume_uploaded_entries(socket, :announcement_docs, fn %{path: path}, entry ->
        if !File.dir?(Path.join("priv/static/uploads/announcements", "#{announcement.id}")) do
          File.mkdir(Path.join("priv/static/uploads/announcements", "#{announcement.id}"))
        end

        file_destination =
          Path.join("priv/static/uploads/announcements/#{announcement.id}", entry.client_name)

        announcement_doc_attr = %{
          "announcement_id" => announcement.id,
          "file_path" => "#{announcement.id}/#{entry.client_name}"
        }

        Uploads.create_announcement_doc(announcement_doc_attr)

        File.cp!(path, file_destination)
        {:ok, file_destination}
      end)

    Endpoint.broadcast(@announcements_topic, "announcement_created", announcement.id)
    notify_parent(:created)
    {:noreply, socket}
  end

  defp create_announcement_handler({:error, changeset}, socket) do
    {:noreply, assign(socket, :announcement, to_form(changeset))}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"

  defp notify_parent(info), do: send(self(), {__MODULE__, info})
end
