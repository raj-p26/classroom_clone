defmodule ClassroomCloneWeb.Submission.Index do
  alias ClassroomClone.Assignments
  alias ClassroomCloneWeb.Submission.GradeComponent
  use ClassroomCloneWeb, :live_view

  @impl true
  def mount(params, %{"user" => user}, socket) do
    assignment_id = params["work_id"]
    class_id = params["id"]
    assignment = Assignments.get_assignment_by_id(assignment_id)

    socket =
      socket
      |> assign(:user, user)
      |> assign(:assignment_id, assignment_id)
      |> assign(:class_id, class_id)

    socket =
      if assignment !== nil && assignment.user_id === user.id do
        init_assigns(socket)
      else
        socket
        |> push_navigate(to: ~p"/")
        |> put_flash(:error, "Something went wrong")
      end

    {:ok, socket}
  end

  defp init_assigns(socket) do
    submissions = Assignments.list_submissions_by_assignment_id(socket.assigns.assignment_id)
    assign(socket, :submissions, submissions)
  end
end
