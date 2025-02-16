defmodule ClassroomCloneWeb.Dashboard do
  use ClassroomCloneWeb, :live_view

  def mount(_params, %{"user" => user}, socket) do
    socket =
      socket
      |> assign(:user, user)
      |> assign(:page_title, "Home")

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
