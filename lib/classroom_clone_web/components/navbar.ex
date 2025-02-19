defmodule ClassroomCloneWeb.Navbar do
  use ClassroomCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <nav class="flex items-center justify-between fixed top-0 left-0 right-0 h-[80px] border-b border-b-outline/80 px-6 bg-surface dark:bg-surface-dark text-on-surface dark:text-on-surface-dark z-[100]">
      <div>
        <.link patch={~p"/dashboard"} class="text-2xl flex items-center gap-2">
          <img src="/images/Google_Classroom_Logo.png" class="h-8" /> Classroom Clone
        </.link>
      </div>
      <ul class="flex items-center justify-around">
        <li>
          <img src={@user.avatar} class="rounded-full h-10" title={@user.email} />
        </li>
        <li>
          <button class="text-button" id="theme-toggle-button" phx-hook="RippleEffect" phx-click="toggle-theme" phx-target={@myself}>
            Light/Dark
          </button>
        </li>
        <li>
          <.link patch={~p"/logout"}>Logout</.link>
        </li>
      </ul>
    </nav>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("toggle-theme", _params, socket) do

    {:noreply, push_event(socket, "toggle-theme", %{})}
  end
end
