defmodule ClassroomClone.AccountsTest do
  use ClassroomClone.DataCase

  alias ClassroomClone.Accounts

  describe "users" do
    alias ClassroomClone.Accounts.User

    import ClassroomClone.AccountsFixtures

    @invalid_attrs %{google_id: nil, username: nil, email: nil, avatar: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{google_id: "some google_id", username: "some username", email: "some email", avatar: "some avatar"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.google_id == "some google_id"
      assert user.username == "some username"
      assert user.email == "some email"
      assert user.avatar == "some avatar"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{google_id: "some updated google_id", username: "some updated username", email: "some updated email", avatar: "some updated avatar"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.google_id == "some updated google_id"
      assert user.username == "some updated username"
      assert user.email == "some updated email"
      assert user.avatar == "some updated avatar"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
