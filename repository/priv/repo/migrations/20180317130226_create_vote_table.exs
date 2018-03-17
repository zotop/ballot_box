defmodule Voting.Repo.Migrations.CreateVoteTable do
  use Ecto.Migration

  def change do
    create table(:vote, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :answer_id, references(:answer, type: :uuid, null: false)
      add :votes, :integer
    end
  end
end
