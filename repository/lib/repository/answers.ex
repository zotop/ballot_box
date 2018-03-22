defmodule Repository.Answers do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "answers" do
    field :answer, :string
    belongs_to :question, Repository.Questions, foreign_key: :question_id, type: :binary_id
    field :votes, :integer
  end
end
