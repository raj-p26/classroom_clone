defmodule ClassroomCloneWeb.PageController do
  use ClassroomCloneWeb, :controller

  def home(conn, _params) do
    conn = assign(conn, :page_title, "Get Started - Classroom Management")
    render(conn, :home, layout: false)
  end

  def redirect_to_dashboard(conn, _params) do
    redirect(conn, to: "/dashboard")
  end
end
