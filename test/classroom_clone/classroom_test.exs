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

  describe "enrollments" do
    alias ClassroomClone.Classroom.Enrollment

    import ClassroomClone.ClassroomFixtures

    @invalid_attrs %{}

    test "list_enrollments/0 returns all enrollments" do
      enrollment = enrollment_fixture()
      assert Classroom.list_enrollments() == [enrollment]
    end

    test "get_enrollment!/1 returns the enrollment with given id" do
      enrollment = enrollment_fixture()
      assert Classroom.get_enrollment!(enrollment.id) == enrollment
    end

    test "create_enrollment/1 with valid data creates a enrollment" do
      valid_attrs = %{}

      assert {:ok, %Enrollment{} = enrollment} = Classroom.create_enrollment(valid_attrs)
    end

    test "create_enrollment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classroom.create_enrollment(@invalid_attrs)
    end

    test "update_enrollment/2 with valid data updates the enrollment" do
      enrollment = enrollment_fixture()
      update_attrs = %{}

      assert {:ok, %Enrollment{} = enrollment} = Classroom.update_enrollment(enrollment, update_attrs)
    end

    test "update_enrollment/2 with invalid data returns error changeset" do
      enrollment = enrollment_fixture()
      assert {:error, %Ecto.Changeset{}} = Classroom.update_enrollment(enrollment, @invalid_attrs)
      assert enrollment == Classroom.get_enrollment!(enrollment.id)
    end

    test "delete_enrollment/1 deletes the enrollment" do
      enrollment = enrollment_fixture()
      assert {:ok, %Enrollment{}} = Classroom.delete_enrollment(enrollment)
      assert_raise Ecto.NoResultsError, fn -> Classroom.get_enrollment!(enrollment.id) end
    end

    test "change_enrollment/1 returns a enrollment changeset" do
      enrollment = enrollment_fixture()
      assert %Ecto.Changeset{} = Classroom.change_enrollment(enrollment)
    end
  end
end
