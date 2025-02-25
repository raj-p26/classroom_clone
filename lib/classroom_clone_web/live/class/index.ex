defmodule ClassroomCloneWeb.Class.Index do
  use ClassroomCloneWeb, :live_view

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
  def handle_params(_params, _uri, socket), do: {:noreply, socket}
end
