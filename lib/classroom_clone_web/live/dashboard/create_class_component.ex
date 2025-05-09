defmodule ClassroomCloneWeb.Dashboard.CreateClassComponent do
  alias ClassroomClone.Classroom
  use ClassroomCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>Create Class</.header>
      <.simple_form
        id="create-class-form"
        for={@class_form}
        phx-change="validate"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input placeholder="Class Name" field={@class_form[:name]} />
        <.input placeholder="Subject" field={@class_form[:subject]} />
        <.input placeholder="Description (Optional)" field={@class_form[:description]} />
        <:actions>
          <.button phx-disable-with="Creating..." class="text-button ml-auto">
            Create
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    class = Classroom.change_class(assigns.class)

    socket =
      socket
      |> assign(assigns)
      |> assign_new(:class_form, fn -> to_form(class) end)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"class" => class}, socket) do
    class = Map.put(class, "user_id", socket.assigns.user.id)
    changeset = Classroom.change_class(socket.assigns.class, class)

    socket =
      socket
      |> assign(:class_form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"class" => class_params}, socket) do
    class_params = Map.put(class_params, "user_id", socket.assigns.user.id)

    case Classroom.create_class(class_params) do
      {:ok, class} ->
        socket =
          socket
          |> put_flash(:info, "Class created")
          |> push_patch(to: ~p"/dashboard")

        class_info = %{
          id: class.id,
          name: class.name,
          subject: class.subject,
          owner: socket.assigns.user.username
        }

        notify_parent(class_info)

        {:noreply, socket}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, :class_form, to_form(changeset))}
    end
  end

  defp notify_parent(info), do: send(self(), info)
end
