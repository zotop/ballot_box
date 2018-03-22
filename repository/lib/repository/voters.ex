defmodule Repository.Voters do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "voters" do
  end
end
