defmodule Voting.Repo.Migrations.CreateVoters do
  use Ecto.Migration

  def change do
    create table(:voter, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :string
      add :last_name, :string
    end
  end
end
