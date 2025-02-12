defmodule ClassroomCloneWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _opts) do
    if conn.private.plug_session["user"] do
      conn
      |> redirect(to: "/dashboard")
      |> halt()
    else
      conn
    end
  end
end
