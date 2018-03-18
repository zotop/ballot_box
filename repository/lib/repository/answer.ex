defmodule Repository.Answer do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "answer" do
    field :answer, :string
    belongs_to :question, Repository.Question, foreign_key: :question_id, type: :binary_id
    has_many :vote, Repository.Vote
  end
end
