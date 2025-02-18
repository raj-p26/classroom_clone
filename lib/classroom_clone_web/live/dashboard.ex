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

    {:ok, socket}
  end

  def assign_new_class_attr(socket) do
    assign(socket, :class, %Class{})
  end

  def assign_user_classes(socket) do
    joined_classes = Classroom.class_by_user(socket.assigns.user.id)
    assign(socket, :joined_classes, joined_classes)
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("join", %{"class_code" => class_code}, socket) do
    class = Classroom.get_class_by_join_code(class_code)

    socket =
      if class == nil do
        put_flash(socket, :error, "No Class Found")
      else
        put_flash(socket, :info, "Joining Class")
      end

    {:noreply, push_patch(socket, to: ~p"/dashboard")}
  end
end
