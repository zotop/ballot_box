defmodule Repository.Question do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "question" do
    field :question, :string
  end
end
