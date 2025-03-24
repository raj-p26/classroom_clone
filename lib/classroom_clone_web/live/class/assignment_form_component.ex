defmodule ClassroomCloneWeb.Class.AssignmentFormComponent do
  alias ClassroomClone.Uploads
  alias ClassroomClone.Assignments.Assignment
  alias ClassroomClone.Assignments
  use ClassroomCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>Create a new assignment</.header>

      <.simple_form
        id="create-assignment-form"
        for={@assignment}
        phx-target={@myself}
        phx-submit="create-assignment"
        phx-change="validate"
      >
        <.input placeholder="Title" value="" field={@assignment[:title]} />
        <.input placeholder="Description(optional)" field={@assignment[:description]} type="textarea" />
        <.input type="date" label="Due Date (optional)" field={@assignment[:due_date]} />

        <div phx-drop-target={@uploads.asgmt_docs.ref} class="border border-dashed rounded-xl py-20">
          <.live_file_input upload={@uploads.asgmt_docs} class="hidden" />
          <label
            class="outlined-button mx-auto cursor-pointer"
            id="upload-files-button"
            phx-hook="RippleEffect"
            for={@uploads.asgmt_docs.ref}
          >
            Browse
          </label>
          <p class="w-fit mx-auto">or drag files here</p>
        </div>
      </.simple_form>

      <p :for={err <- upload_errors(@uploads.asgmt_docs)} class="text-error">
        {error_to_string(err)}
      </p>
      <div :for={entry <- @uploads.asgmt_docs.entries} class="flex items-center justify-between mt-4">
        <p>{entry.client_name}</p>
        <button
          class="text-button"
          phx-click="cancel-upload"
          phx-value-ref={entry.ref}
          phx-target={@myself}
        >
          <.icon name="hero-x-mark" class="cursor-pointer" />
        </button>
      </div>
      <button
        class="text-button mt-4"
        form="create-assignment-form"
        phx-hook="RippleEffect"
        id="create-asgmt-btn"
      >
        Post
      </button>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    assignment = Assignments.change_assignment(%Assignment{})

    socket =
      socket
      |> assign(assigns)
      |> assign_new(:assignment, fn -> to_form(assignment) end)
      |> allow_upload(:asgmt_docs,
        accept: ~w(.jpg .png .jpeg .pdf .docx .ppt .xlsx .csv .zip .rar .tar)
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("create-assignment", %{"assignment" => asgmt_params}, socket) do
    asgmt_params = Map.put(asgmt_params, "class_id", socket.assigns.class_id)

    handle_asgmt_create(Assignments.create_assignment(asgmt_params), socket)
  end

  @impl true
  def handle_event("validate", _params, socket), do: {:noreply, socket}

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :asgmt_docs, ref)}
  end

  defp handle_asgmt_create({:ok, asgmt}, socket) do
    _ =
      consume_uploaded_entries(socket, :asgmt_docs, fn %{path: path}, entry ->
        if !File.dir?(Path.join("priv/static/uploads/assignments", "#{asgmt.id}")) do
          File.mkdir(Path.join("priv/static/uploads/assignments", "#{asgmt.id}"))
        end

        file_destination =
          Path.join("priv/static/uploads/assignments/#{asgmt.id}", entry.client_name)

        asgmt_doc_attr = %{
          "assignment_id" => asgmt.id,
          "file_path" => "#{asgmt.id}/#{entry.client_name}"
        }

        Uploads.create_assignment_doc(asgmt_doc_attr)

        File.cp!(path, file_destination)
        {:ok, file_destination}
      end)

    notify_parent(:created)
    {:noreply, socket}
  end

  defp handle_asgmt_create({:error, changeset}, socket) do
    {:noreply, assign(socket, :assignment, to_form(changeset))}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"

  defp notify_parent(info), do: send(self(), {__MODULE__, info})
end
