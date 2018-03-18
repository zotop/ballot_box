defmodule Repository.Vote do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "vote" do
    field :votes, :integer, default: 0
    belongs_to :question, Repository.Question, foreign_key: :question_id, type: :binary_id
    belongs_to :answer, Repository.Answer, foreign_key: :answer_id, type: :binary_id
  end
end
