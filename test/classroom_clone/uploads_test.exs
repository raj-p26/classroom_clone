defmodule ClassroomClone.UploadsTest do
  use ClassroomClone.DataCase

  alias ClassroomClone.Uploads

  describe "announcement_docs" do
    alias ClassroomClone.Uploads.AnnouncementDoc

    import ClassroomClone.UploadsFixtures

    @invalid_attrs %{file_path: nil}

    test "list_announcement_docs/0 returns all announcement_docs" do
      announcement_doc = announcement_doc_fixture()
      assert Uploads.list_announcement_docs() == [announcement_doc]
    end

    test "get_announcement_doc!/1 returns the announcement_doc with given id" do
      announcement_doc = announcement_doc_fixture()
      assert Uploads.get_announcement_doc!(announcement_doc.id) == announcement_doc
    end

    test "create_announcement_doc/1 with valid data creates a announcement_doc" do
      valid_attrs = %{file_path: "some file_path"}

      assert {:ok, %AnnouncementDoc{} = announcement_doc} = Uploads.create_announcement_doc(valid_attrs)
      assert announcement_doc.file_path == "some file_path"
    end

    test "create_announcement_doc/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Uploads.create_announcement_doc(@invalid_attrs)
    end

    test "update_announcement_doc/2 with valid data updates the announcement_doc" do
      announcement_doc = announcement_doc_fixture()
      update_attrs = %{file_path: "some updated file_path"}

      assert {:ok, %AnnouncementDoc{} = announcement_doc} = Uploads.update_announcement_doc(announcement_doc, update_attrs)
      assert announcement_doc.file_path == "some updated file_path"
    end

    test "update_announcement_doc/2 with invalid data returns error changeset" do
      announcement_doc = announcement_doc_fixture()
      assert {:error, %Ecto.Changeset{}} = Uploads.update_announcement_doc(announcement_doc, @invalid_attrs)
      assert announcement_doc == Uploads.get_announcement_doc!(announcement_doc.id)
    end

    test "delete_announcement_doc/1 deletes the announcement_doc" do
      announcement_doc = announcement_doc_fixture()
      assert {:ok, %AnnouncementDoc{}} = Uploads.delete_announcement_doc(announcement_doc)
      assert_raise Ecto.NoResultsError, fn -> Uploads.get_announcement_doc!(announcement_doc.id) end
    end

    test "change_announcement_doc/1 returns a announcement_doc changeset" do
      announcement_doc = announcement_doc_fixture()
      assert %Ecto.Changeset{} = Uploads.change_announcement_doc(announcement_doc)
    end
  end

  describe "assignment_docs" do
    alias ClassroomClone.Uploads.AssignmentDoc

    import ClassroomClone.UploadsFixtures

    @invalid_attrs %{file_path: nil}

    test "list_assignment_docs/0 returns all assignment_docs" do
      assignment_doc = assignment_doc_fixture()
      assert Uploads.list_assignment_docs() == [assignment_doc]
    end

    test "get_assignment_doc!/1 returns the assignment_doc with given id" do
      assignment_doc = assignment_doc_fixture()
      assert Uploads.get_assignment_doc!(assignment_doc.id) == assignment_doc
    end

    test "create_assignment_doc/1 with valid data creates a assignment_doc" do
      valid_attrs = %{file_path: "some file_path"}

      assert {:ok, %AssignmentDoc{} = assignment_doc} = Uploads.create_assignment_doc(valid_attrs)
      assert assignment_doc.file_path == "some file_path"
    end

    test "create_assignment_doc/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Uploads.create_assignment_doc(@invalid_attrs)
    end

    test "update_assignment_doc/2 with valid data updates the assignment_doc" do
      assignment_doc = assignment_doc_fixture()
      update_attrs = %{file_path: "some updated file_path"}

      assert {:ok, %AssignmentDoc{} = assignment_doc} = Uploads.update_assignment_doc(assignment_doc, update_attrs)
      assert assignment_doc.file_path == "some updated file_path"
    end

    test "update_assignment_doc/2 with invalid data returns error changeset" do
      assignment_doc = assignment_doc_fixture()
      assert {:error, %Ecto.Changeset{}} = Uploads.update_assignment_doc(assignment_doc, @invalid_attrs)
      assert assignment_doc == Uploads.get_assignment_doc!(assignment_doc.id)
    end

    test "delete_assignment_doc/1 deletes the assignment_doc" do
      assignment_doc = assignment_doc_fixture()
      assert {:ok, %AssignmentDoc{}} = Uploads.delete_assignment_doc(assignment_doc)
      assert_raise Ecto.NoResultsError, fn -> Uploads.get_assignment_doc!(assignment_doc.id) end
    end

    test "change_assignment_doc/1 returns a assignment_doc changeset" do
      assignment_doc = assignment_doc_fixture()
      assert %Ecto.Changeset{} = Uploads.change_assignment_doc(assignment_doc)
    end
  end
end
