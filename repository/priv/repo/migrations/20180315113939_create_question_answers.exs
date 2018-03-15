defmodule Voting.Repo.Migrations.CreateQuestionAnswers do
  use Ecto.Migration

  def change do
    create table(:question_answer, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :question_id, references(:question, type: :uuid, null: false)
      add :answer, :string
    end
  end
end
