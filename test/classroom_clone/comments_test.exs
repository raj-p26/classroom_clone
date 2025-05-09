defmodule ClassroomClone.CommentsTest do
  use ClassroomClone.DataCase

  alias ClassroomClone.Comments

  describe "comments" do
    alias ClassroomClone.Comments.Comment

    import ClassroomClone.CommentsFixtures

    @invalid_attrs %{content: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Comments.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Comment{} = comment} = Comments.create_comment(valid_attrs)
      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, update_attrs)
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end

  describe "assignment_comments" do
    alias ClassroomClone.Comments.AssignmentComment

    import ClassroomClone.CommentsFixtures

    @invalid_attrs %{content: nil}

    test "list_assignment_comments/0 returns all assignment_comments" do
      assignment_comment = assignment_comment_fixture()
      assert Comments.list_assignment_comments() == [assignment_comment]
    end

    test "get_assignment_comment!/1 returns the assignment_comment with given id" do
      assignment_comment = assignment_comment_fixture()
      assert Comments.get_assignment_comment!(assignment_comment.id) == assignment_comment
    end

    test "create_assignment_comment/1 with valid data creates a assignment_comment" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %AssignmentComment{} = assignment_comment} = Comments.create_assignment_comment(valid_attrs)
      assert assignment_comment.content == "some content"
    end

    test "create_assignment_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_assignment_comment(@invalid_attrs)
    end

    test "update_assignment_comment/2 with valid data updates the assignment_comment" do
      assignment_comment = assignment_comment_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %AssignmentComment{} = assignment_comment} = Comments.update_assignment_comment(assignment_comment, update_attrs)
      assert assignment_comment.content == "some updated content"
    end

    test "update_assignment_comment/2 with invalid data returns error changeset" do
      assignment_comment = assignment_comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.update_assignment_comment(assignment_comment, @invalid_attrs)
      assert assignment_comment == Comments.get_assignment_comment!(assignment_comment.id)
    end

    test "delete_assignment_comment/1 deletes the assignment_comment" do
      assignment_comment = assignment_comment_fixture()
      assert {:ok, %AssignmentComment{}} = Comments.delete_assignment_comment(assignment_comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_assignment_comment!(assignment_comment.id) end
    end

    test "change_assignment_comment/1 returns a assignment_comment changeset" do
      assignment_comment = assignment_comment_fixture()
      assert %Ecto.Changeset{} = Comments.change_assignment_comment(assignment_comment)
    end
  end
end
