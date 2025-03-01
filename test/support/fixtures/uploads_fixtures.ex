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
end
