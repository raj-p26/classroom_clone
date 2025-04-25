defmodule ClassroomClone.UploadsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClassroomClone.Uploads` context.
  """

  @doc """
  Generate a announcement_doc.
  """
  def announcement_doc_fixture(attrs \\ %{}) do
    {:ok, announcement_doc} =
      attrs
      |> Enum.into(%{
        file_path: "some file_path"
      })
      |> ClassroomClone.Uploads.create_announcement_doc()

    announcement_doc
  end

  @doc """
  Generate a assignment_doc.
  """
  def assignment_doc_fixture(attrs \\ %{}) do
    {:ok, assignment_doc} =
      attrs
      |> Enum.into(%{
        file_path: "some file_path"
      })
      |> ClassroomClone.Uploads.create_assignment_doc()

    assignment_doc
  end

  @doc """
  Generate a submission_doc.
  """
  def submission_doc_fixture(attrs \\ %{}) do
    {:ok, submission_doc} =
      attrs
      |> Enum.into(%{
        file_name: "some file_name"
      })
      |> ClassroomClone.Uploads.create_submission_doc()

    submission_doc
  end
end
