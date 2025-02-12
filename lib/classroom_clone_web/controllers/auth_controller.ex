defmodule ClassroomCloneWeb.AuthController do
  use ClassroomCloneWeb, :controller

  alias ClassroomClone.Accounts

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_info = %{
      google_id: auth.uid,
      username: auth.info.name,
      email: auth.info.email,
      avatar: auth.info.image
    }

    case Accounts.get_user_by_google_id(auth.uid) do
      nil ->
        Accounts.create_user(user_info)

      user ->
        Accounts.update_user(user, user_info)
    end

    conn
    |> put_session(:user, user_info)
    |> put_flash(:info, "Logged In Successfully")
    |> redirect(to: "/dashboard")
  end

  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    IO.inspect(failure)

    conn
    |> put_flash(:error, "Unable to authenticate")
    |> redirect(to: "/")
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged Out Successfully")
    |> redirect(to: "/auth")
  end
end
