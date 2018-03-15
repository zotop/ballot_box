defmodule Repository.QuestionAnswer do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "question_answer" do
    field :question_id, references(:question, type: :uuid, null: false)
    field :answer, :string
    belongs_to :question, Repository.Question, type: :binary_id
  end
end
