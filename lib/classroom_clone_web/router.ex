defmodule ClassroomCloneWeb.Router do
  use ClassroomCloneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ClassroomCloneWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :redirect_if_authenticated do
    plug ClassroomCloneWeb.UserAuth
  end

  pipeline :require_authenticated do
    plug :auth_required
  end

  scope "/", ClassroomCloneWeb do
    pipe_through [:browser, :auth_required]

    get "/", PageController, :redirect_to_dashboard
    get "/logout", AuthController, :logout

    live "/dashboard", Dashboard.Index
    live "/join", Dashboard.Index, :join
    live "/create", Dashboard.Index, :create

    live "/c/:id", Class.Index, :stream
    live "/c/:id/people", Class.Index, :people
    live "/c/:id/grades", Class.Index, :grades

    live "/c/:id/a/:announcement_id", Announcements.Index
  end

  scope "/auth", ClassroomCloneWeb do
    pipe_through [:browser, :redirect_if_authenticated]

    get "/", PageController, :home
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", ClassroomCloneWeb do
  #   pipe_through :api
  # end

  def auth_required(conn, _opts) do
    if !conn.private.plug_session["user"] do
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: "/auth")
      |> halt()
    else
      conn
    end
  end
end
