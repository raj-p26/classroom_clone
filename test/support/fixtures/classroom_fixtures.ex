defmodule ClassroomClone.ClassroomFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClassroomClone.Classroom` context.
  """

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> ClassroomClone.Classroom.create_class()

    class
  end
end
