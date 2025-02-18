defmodule ClassroomCloneWeb.Dashboard do
  alias ClassroomClone.Classroom.Class
  alias ClassroomCloneWeb.CreateClassComponent
  alias ClassroomClone.Classroom
  use ClassroomCloneWeb, :live_view

  def mount(_params, %{"user" => user}, socket) do
    socket =
      socket
      |> assign(:user, user)
      |> assign(:page_title, "Home")
      |> assign_new_class_attr()
      |> assign_user_classes()
      |> assign_enrolled_classes()

    {:ok, socket}
  end

  def assign_new_class_attr(socket) do
    assign(socket, :class, %Class{})
  end

  def assign_user_classes(socket) do
    owned_classes = Classroom.class_by_user(socket.assigns.user.id)

    stream(socket, :owned_classes, owned_classes)
  end

  def assign_enrolled_classes(socket) do
    enrolled_classes = Classroom.enrolled_classes_by_user(socket.assigns.user.id)

    stream(socket, :enrolled_classes, enrolled_classes)
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("join", %{"class_code" => class_code}, socket) do
    class = Classroom.get_class_by_join_code(class_code)

    socket =
      case Classroom.check_if_user_exists(class_code, socket.assigns.user.id) do
        {:ok, _} ->
          Classroom.create_enrollment(%{class_id: class_code, user_id: socket.assigns.user.id})
          put_flash(socket, :info, "Joining Class")

        {:error, err} ->
          put_flash(socket, :error, err)
      end

    socket =
      if class == nil do
        put_flash(socket, :error, "No Class Found")
      else
        socket
      end

    {:noreply, push_patch(socket, to: ~p"/dashboard")}
  end
end
