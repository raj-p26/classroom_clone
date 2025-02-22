defmodule ClassroomCloneWeb.Class.Index do
  use ClassroomCloneWeb, :live_view

  embed_templates "tabs/*"

  @impl true
  def mount(params, %{"user" => user}, socket) do
    socket =
      socket
      |> assign(:user, user)
      |> assign(:class_id, params["id"])
      |> assign(:current_tab, "tab-1")

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"tab" => tab}, _uri, socket) do
    {:noreply, assign(socket, :current_tab, tab)}
  end
end
