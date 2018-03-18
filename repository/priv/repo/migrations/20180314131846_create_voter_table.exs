defmodule Voting.Repo.Migrations.CreateVoterTable do
  use Ecto.Migration

  def change do
    create table(:voter, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
    end
  end
end
