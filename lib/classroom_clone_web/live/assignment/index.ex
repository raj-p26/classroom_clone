defmodule ClassroomCloneWeb.Assignment.Index do
  alias ClassroomClone.Assignments
  use ClassroomCloneWeb, :live_view

  def mount(params, %{"user" => user}, socket) do
    %{
      "id" => class_id,
      "work_id" => asgmt_id
    } = params

    socket =
      socket
      |> assign(:user, user)
      |> assign(:class_id, class_id)
      |> assign(:assignment_id, asgmt_id)
      |> assign_assignment

    {:ok, socket}
  end

  defp assign_assignment(socket) do
    asgmt_id = socket.assigns.assignment_id

    assignment = Assignments.get_assignment(asgmt_id)

    assign(socket, :assignment, assignment)
  end
end
