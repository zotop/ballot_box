defmodule Repository.Voter do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "voter" do
    field :first_name, :string
    field :last_name, :string
  end
end
