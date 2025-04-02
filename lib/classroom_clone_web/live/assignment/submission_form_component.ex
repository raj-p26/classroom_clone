defmodule ClassroomCloneWeb.Assignment.SubmissionFormComponent do
  alias ClassroomClone.Assignments
  alias ClassroomClone.Assignments.Submission
  use ClassroomCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>Submit your work</.header>
      <.simple_form
        for={@submission}
        id="submission-form"
        phx-change="validate"
        phx-target={@myself}
        phx-submit="submit-assignment"
      >
        <div
          phx-drop-target={@uploads.submission_docs.ref}
          class="border border-dashed rounded-xl py-20"
        >
          <.live_file_input upload={@uploads.submission_docs} class="hidden" />
          <label
            class="outlined-button mx-auto cursor-pointer"
            id="upload-files-button"
            phx-hook="RippleEffect"
            for={@uploads.submission_docs.ref}
          >
            Browse
          </label>
          <p class="w-fit mx-auto">or drag files here</p>
        </div>
      </.simple_form>
      <p :for={err <- upload_errors(@uploads.submission_docs)} class="text-error">
        {error_to_string(err)}
      </p>
      <div
        :for={entry <- @uploads.submission_docs.entries}
        class="flex items-center justify-between mt-4"
      >
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
        class="filled-tonal-button mt-4"
        disabled={if(@uploads.submission_docs.entries === [], do: true, else: false)}
        form="submission-form"
      >
        Submit
      </button>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    submission = Assignments.change_submission(%Submission{})

    socket =
      socket
      |> assign(assigns)
      |> allow_upload(:submission_docs,
        max_entries: 5,
        accept: ~w(.jpg .png .jpeg .pdf .docx .ppt .xlsx .csv .zip .rar .tar)
      )
      |> assign_new(:submission, fn -> to_form(submission) end)

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :submission_docs, ref)}
  end

  @impl true
  def handle_event("submit-assignment", _params, socket) do
    user_id = socket.assigns.user_id
    assignment_id = socket.assigns.assignment_id

    _ =
      consume_uploaded_entries(socket, :submission_docs, fn %{path: path}, entry ->
        {:ok, submission} =
          Assignments.create_submission(%{
            "user_id" => user_id,
            "assignment_id" => assignment_id,
            "file_name" => entry.client_name
          })

        if !File.dir?(Path.join("priv/static/uploads/submissions", "#{submission.user_id}")) do
          File.mkdir(Path.join("priv/static/uploads/submissions", "#{submission.user_id}"))
        end

        file_destination =
          Path.join("priv/static/uploads/submissions/#{submission.user_id}", entry.client_name)

        File.cp!(path, file_destination)
        {:ok, file_destination}
      end)

    notify_parent(:submitted)
    {:noreply, socket}
  end

  defp notify_parent(info), do: send(self(), {__MODULE__, info})

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
end
