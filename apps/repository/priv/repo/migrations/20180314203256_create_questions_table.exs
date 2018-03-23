defmodule Voting.Repo.Migrations.CreateQuestionsTable do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :question, :string
    end
  end
end
