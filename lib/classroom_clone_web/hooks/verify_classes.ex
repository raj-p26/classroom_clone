defmodule ClassroomCloneWeb.Hooks.VerifyClasses do
  alias ClassroomClone.Classroom

  def user_in_class?(class_id, user_id) do
    class = Classroom.get_class(class_id)
    if class === nil, do: raise("Class not found")

    user_enrolled? = Classroom.user_enrolled?(class_id, user_id)

    if user_enrolled? || class_owner?(class_id, user_id) do
      {:ok, true}
    else
      raise "Class not available"
    end
  rescue
    e -> {:error, Exception.message(e)}
  end

  defp class_owner?(class_id, user_id) do
    class = Classroom.get_class(class_id)

    if !class do
      false
    else
      class.user_id == user_id
    end
  end
end
