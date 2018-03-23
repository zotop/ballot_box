defmodule Voting.Repo.Migrations.CreateAnswersTable do
  use Ecto.Migration

  def change do
    create table(:answers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :question_id, references(:questions, type: :binary_id, null: false)
      add :answer, :string
      add :votes, :integer
    end
  end
end
