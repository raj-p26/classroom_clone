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

    current_user =
      case Accounts.get_user_by_google_id(auth.uid) do
        nil ->
          {:ok, user} = Accounts.create_user(user_info)
          user

        existing_user ->
          {:ok, user} = Accounts.update_user(existing_user, user_info)
          user
      end

    conn
    |> put_session(:user, current_user)
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
