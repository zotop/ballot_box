defmodule Repository.Question do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "question" do
    field :question, :string
    has_many :answer, Repository.Answer
  end

  def changeset(question, params \\ %{}) do
    question
    |> cast(params, [:question])
    |> cast_assoc(:answer)
  end
end
