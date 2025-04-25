defmodule ClassroomCloneWeb.Submission.GradeComponent do
  alias ClassroomClone.Assignments
  alias ClassroomClone.Assignments.Grade
  use ClassroomCloneWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@grade_form}
        id="save-grade-#{@id}"
        phx-submit="save-grade"
        phx-target={@myself}
      >
        <div class="flex items-center">
          <div class="w-[100px]">
            <.input field={@grade_form[:score]} type="number" placeholder="Grade" />
            <.input type="hidden" field={@grade_form[:assignment_id]} />
            <.input type="hidden" field={@grade_form[:submission_id]} />
            <.input type="hidden" field={@grade_form[:user_id]} />
          </div>
          <p>&nbsp;&sol; 100</p>
        </div>
      </.simple_form>
    </div>
    """
  end

  def update(assigns, socket) do
    %{
      grade_id: grade_id,
      assignment_id: _assignment_id,
      submission_id: submission_id,
      user_id: user_id
    } = assigns

    {grade, action} =
      if grade_id == "" do
        grade_changeset =
          %Grade{
            submission_id: submission_id,
            user_id: user_id
          }

        {grade_changeset, :new}
      else
        g = Assignments.get_grade!(grade_id)
        {g, :update}
      end

    socket =
      socket
      |> assign(assigns)
      |> assign(:action, action)
      |> assign(:grade, grade)
      |> assign(:grade_form, to_form(Assignments.change_grade(grade)))

    {:ok, socket}
  end

  def handle_event("save-grade", %{"grade" => grade_params}, socket) do
    socket = save_grade(socket, grade_params, socket.assigns.action)

    {:noreply, socket}
  end

  defp save_grade(socket, grade_params, :new) do
    case Assignments.create_grade(grade_params) do
      {:ok, grade} ->
        grade_changeset = Assignments.change_grade(grade)

        socket
        |> assign(:grade_form, to_form(grade_changeset))
        |> put_flash(:info, "Student Graded")

      {:error, e} ->
        IO.inspect(e)
        put_flash(socket, :error, "Error")
    end
  end

  defp save_grade(socket, grade_params, :update) do
    case Assignments.update_grade(socket.assigns.grade, grade_params) do
      {:ok, _updated} -> put_flash(socket, :info, "Grading updated")
      {:error, _e} -> put_flash(socket, :error, "Something went wrong")
    end
  end
end
