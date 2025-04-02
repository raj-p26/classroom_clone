defmodule ClassroomClone.AssignmentsTest do
  use ClassroomClone.DataCase

  alias ClassroomClone.Assignments

  describe "assignments" do
    alias ClassroomClone.Assignments.Assignment

    import ClassroomClone.AssignmentsFixtures

    @invalid_attrs %{description: nil, title: nil, due_date: nil}

    test "list_assignments/0 returns all assignments" do
      assignment = assignment_fixture()
      assert Assignments.list_assignments() == [assignment]
    end

    test "get_assignment!/1 returns the assignment with given id" do
      assignment = assignment_fixture()
      assert Assignments.get_assignment!(assignment.id) == assignment
    end

    test "create_assignment/1 with valid data creates a assignment" do
      valid_attrs = %{description: "some description", title: "some title", due_date: ~D[2025-03-18]}

      assert {:ok, %Assignment{} = assignment} = Assignments.create_assignment(valid_attrs)
      assert assignment.description == "some description"
      assert assignment.title == "some title"
      assert assignment.due_date == ~D[2025-03-18]
    end

    test "create_assignment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assignments.create_assignment(@invalid_attrs)
    end

    test "update_assignment/2 with valid data updates the assignment" do
      assignment = assignment_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", due_date: ~D[2025-03-19]}

      assert {:ok, %Assignment{} = assignment} = Assignments.update_assignment(assignment, update_attrs)
      assert assignment.description == "some updated description"
      assert assignment.title == "some updated title"
      assert assignment.due_date == ~D[2025-03-19]
    end

    test "update_assignment/2 with invalid data returns error changeset" do
      assignment = assignment_fixture()
      assert {:error, %Ecto.Changeset{}} = Assignments.update_assignment(assignment, @invalid_attrs)
      assert assignment == Assignments.get_assignment!(assignment.id)
    end

    test "delete_assignment/1 deletes the assignment" do
      assignment = assignment_fixture()
      assert {:ok, %Assignment{}} = Assignments.delete_assignment(assignment)
      assert_raise Ecto.NoResultsError, fn -> Assignments.get_assignment!(assignment.id) end
    end

    test "change_assignment/1 returns a assignment changeset" do
      assignment = assignment_fixture()
      assert %Ecto.Changeset{} = Assignments.change_assignment(assignment)
    end
  end

  describe "submissions" do
    alias ClassroomClone.Assignments.Submission

    import ClassroomClone.AssignmentsFixtures

    @invalid_attrs %{file_path: nil}

    test "list_submissions/0 returns all submissions" do
      submission = submission_fixture()
      assert Assignments.list_submissions() == [submission]
    end

    test "get_submission!/1 returns the submission with given id" do
      submission = submission_fixture()
      assert Assignments.get_submission!(submission.id) == submission
    end

    test "create_submission/1 with valid data creates a submission" do
      valid_attrs = %{file_path: "some file_path"}

      assert {:ok, %Submission{} = submission} = Assignments.create_submission(valid_attrs)
      assert submission.file_path == "some file_path"
    end

    test "create_submission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assignments.create_submission(@invalid_attrs)
    end

    test "update_submission/2 with valid data updates the submission" do
      submission = submission_fixture()
      update_attrs = %{file_path: "some updated file_path"}

      assert {:ok, %Submission{} = submission} = Assignments.update_submission(submission, update_attrs)
      assert submission.file_path == "some updated file_path"
    end

    test "update_submission/2 with invalid data returns error changeset" do
      submission = submission_fixture()
      assert {:error, %Ecto.Changeset{}} = Assignments.update_submission(submission, @invalid_attrs)
      assert submission == Assignments.get_submission!(submission.id)
    end

    test "delete_submission/1 deletes the submission" do
      submission = submission_fixture()
      assert {:ok, %Submission{}} = Assignments.delete_submission(submission)
      assert_raise Ecto.NoResultsError, fn -> Assignments.get_submission!(submission.id) end
    end

    test "change_submission/1 returns a submission changeset" do
      submission = submission_fixture()
      assert %Ecto.Changeset{} = Assignments.change_submission(submission)
    end
  end
end
