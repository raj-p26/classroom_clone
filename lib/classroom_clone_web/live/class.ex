defmodule ClassroomCloneWeb.Class do
  use ClassroomCloneWeb, :live_view

  def mount(params, %{"user" => user}, socket) do
    IO.inspect(params)
    {:ok, assign(socket, :user, user)}
  end
end
