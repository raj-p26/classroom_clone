defmodule ClassroomClone.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClassroomClone.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> ClassroomClone.Comments.create_comment()

    comment
  end

  @doc """
  Generate a assignment_comment.
  """
  def assignment_comment_fixture(attrs \\ %{}) do
    {:ok, assignment_comment} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> ClassroomClone.Comments.create_assignment_comment()

    assignment_comment
  end
end
