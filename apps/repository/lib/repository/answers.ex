defmodule Repository.Answers do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "answers" do
    field(:answer, :string)
    belongs_to(:questions, Repository.Questions, type: :binary_id)
    field(:votes, :integer)
  end
end
