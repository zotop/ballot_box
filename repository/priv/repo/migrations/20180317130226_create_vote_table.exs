defmodule Voting.Repo.Migrations.CreateVoteTable do
  use Ecto.Migration

  def change do
    create table(:vote, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :question_id, references(:question, type: :binary_id, null: false)
      add :answer_id, references(:answer, type: :binary_id, null: false)
      add :votes, :integer
    end
  end
end
