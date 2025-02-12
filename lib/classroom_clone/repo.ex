defmodule ClassroomClone.Repo do
  use Ecto.Repo,
    otp_app: :classroom_clone,
    adapter: Ecto.Adapters.SQLite3
end
