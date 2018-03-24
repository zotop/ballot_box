defmodule Repository.Questions do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:id, :question, :answers]}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "questions" do
    field(:question, :string)
    has_many(:answers, Repository.Answers)
  end

  def changeset(question, params \\ %{}) do
    question
    |> cast(params, [:question])
    |> cast_assoc(:answers)
  end
end
