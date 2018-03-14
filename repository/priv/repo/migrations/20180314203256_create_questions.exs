defmodule Voting.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:question, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :question, :string
    end
  end
end
