defmodule ClassroomCloneWeb.Dashboard do
  alias ClassroomClone.Classroom.Class
  alias ClassroomCloneWeb.CreateClassComponent
  use ClassroomCloneWeb, :live_view

  def mount(_params, %{"user" => user}, socket) do
    socket =
      socket
      |> assign(:user, user)
      |> assign(:page_title, "Home")
      |> assign_new_class_attr()

    {:ok, socket}
  end

  def assign_new_class_attr(socket) do
    assign(socket, :class, %Class{})
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
