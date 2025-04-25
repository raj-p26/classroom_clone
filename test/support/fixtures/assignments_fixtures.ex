defmodule ClassroomClone.AssignmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClassroomClone.Assignments` context.
  """

  @doc """
  Generate a assignment.
  """
  def assignment_fixture(attrs \\ %{}) do
    {:ok, assignment} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: ~D[2025-03-18],
        title: "some title"
      })
      |> ClassroomClone.Assignments.create_assignment()

    assignment
  end

  @doc """
  Generate a submission.
  """
  def submission_fixture(attrs \\ %{}) do
    {:ok, submission} =
      attrs
      |> Enum.into(%{
        file_path: "some file_path"
      })
      |> ClassroomClone.Assignments.create_submission()

    submission
  end

  @doc """
  Generate a grade.
  """
  def grade_fixture(attrs \\ %{}) do
    {:ok, grade} =
      attrs
      |> Enum.into(%{
        grades: "120.5"
      })
      |> ClassroomClone.Assignments.create_grade()

    grade
  end
end
