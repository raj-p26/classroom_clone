defmodule ClassroomClone.ClassroomTest do
  use ClassroomClone.DataCase

  alias ClassroomClone.Classroom

  describe "classes" do
    alias ClassroomClone.Classroom.Class

    import ClassroomClone.ClassroomFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_classes/0 returns all classes" do
      class = class_fixture()
      assert Classroom.list_classes() == [class]
    end

    test "get_class!/1 returns the class with given id" do
      class = class_fixture()
      assert Classroom.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Class{} = class} = Classroom.create_class(valid_attrs)
      assert class.name == "some name"
      assert class.description == "some description"
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classroom.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = class_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Class{} = class} = Classroom.update_class(class, update_attrs)
      assert class.name == "some updated name"
      assert class.description == "some updated description"
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = class_fixture()
      assert {:error, %Ecto.Changeset{}} = Classroom.update_class(class, @invalid_attrs)
      assert class == Classroom.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = class_fixture()
      assert {:ok, %Class{}} = Classroom.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Classroom.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      class = class_fixture()
      assert %Ecto.Changeset{} = Classroom.change_class(class)
    end
  end
end
