defmodule ClassroomCloneWeb.Class do
  use ClassroomCloneWeb, :live_view

  def mount(_params, %{"user" => user}, socket) do
    {:ok, assign(socket, :user, user)}
  end

  def handle_event("modal_open", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
