defmodule Voting.Repo.Migrations.CreateAnswerTable do
  use Ecto.Migration

  def change do
    create table(:answer, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :question_id, references(:question, type: :binary_id, null: false)
      add :answer, :string
      add :votes, :integer
    end
  end
end
