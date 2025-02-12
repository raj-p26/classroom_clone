defmodule ClassroomClone.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClassroomClone.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user google_id.
  """
  def unique_user_google_id, do: "some google_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar: "some avatar",
        email: unique_user_email(),
        google_id: unique_user_google_id(),
        username: "some username"
      })
      |> ClassroomClone.Accounts.create_user()

    user
  end
end
