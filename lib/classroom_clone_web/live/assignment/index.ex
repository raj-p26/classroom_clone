defmodule ClassroomCloneWeb.Assignment.Index do
  alias ClassroomCloneWeb.Endpoint
  alias ClassroomClone.Comments
  alias ClassroomClone.Assignments
  alias ClassroomCloneWeb.Assignment.CreateCommentComponent
  alias ClassroomCloneWeb.Assignment.SubmissionFormComponent

  use ClassroomCloneWeb, :live_view

  @assignment_comments_topic "assignment comments"

  @impl true
  def mount(params, %{"user" => user}, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@assignment_comments_topic)
    end

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
      |> assign(:make_submission, false)
      |> assign_submission
      |> stream_comments

    {:ok, socket}
  end

  defp assign_assignment(socket) do
    asgmt_id = socket.assigns.assignment_id

    assignment = Assignments.get_assignment(asgmt_id)

    assign(socket, :assignment, assignment)
  end

  defp assign_submission(socket) do
    user_id = socket.assigns.user.id
    assignment_id = socket.assigns.assignment_id
    submission = Assignments.get_submission(user_id, assignment_id)

    socket
    |> assign(:submission, submission)
    |> assign(:submitted, submission !== [])
  end

  defp stream_comments(socket) do
    comments = Comments.list_assignment_comments(socket.assigns.assignment_id)

    stream(socket, :comments, comments)
  end

  @impl true
  def handle_info(%{event: "comment-created"} = info, socket) do
    %{payload: comment_id} = info
    comment = Comments.get_assignment_comment(comment_id)
    {:noreply, stream_insert(socket, :comments, comment, at: 0)}
  end

  @impl true
  def handle_info({CreateCommentComponent, :created}, socket) do
    {:noreply, put_flash(socket, :info, "Comment posted")}
  end

  @impl true
  def handle_info({SubmissionFormComponent, :submitted}, socket) do
    socket =
      socket
      |> assign_submission
      |> update(:make_submission, fn _ -> false end)
      |> put_flash(:info, "Work submitted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("make-submission", _params, socket) do
    {:noreply, update(socket, :make_submission, fn _ -> true end)}
  end

  @impl true
  def handle_event("cancel-submission", _params, socket) do
    {:noreply, update(socket, :make_submission, fn _ -> false end)}
  end

  defp show_comment(assigns) do
    ~H"""
    <div class="border border-outline/30 dark:border-outline-dark/30 rounded-lg p-4 my-2" id={@id}>
      <div class="flex items-center gap-4 px-4">
        <img src={@comment.user_avatar} class="rounded-full size-12" />
        <div>
          <p>{@comment.username}</p>
          <p class="text-sm font-light">
            {Calendar.strftime(@comment.commented_at, "%B %d, %Y [%I:%M %p]")}
          </p>
        </div>
      </div>
      <hr class="my-2 border-outline dark:border-outline-dark opacity-30" />
      <h1 class="text-lg">{@comment.content}</h1>
    </div>
    """
  end
end
