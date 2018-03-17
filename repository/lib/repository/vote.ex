defmodule Repository.Vote do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "vote" do
    field :votes, :integer
    belongs_to :answer, Repository.Answer
  end
end
