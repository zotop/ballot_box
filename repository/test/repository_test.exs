defmodule RepositoryTest do
  import Ecto.Query, only: [from: 2]
  use ExUnit.Case

  doctest Repository


  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Voting.Repo)
  end


  test "greets the world" do
    assert Repository.hello() == :world
  end

  test "create a question" do
    question = "What is my name?"
    answers = ["John", "Julia"]
    created_question = Repository.create_question(question, answers)
    answer_1 = Enum.at(created_question.answer, 0).answer
    answer_2 = Enum.at(created_question.answer, 1).answer

    assert created_question.question == question
    assert length(created_question.answer) == 2
    assert answers -- [answer_1, answer_2] == []
  end

  test "create a voter" do
    created_voter = Repository.create_voter()
    number_of_voters = Voting.Repo.aggregate(Repository.Voter, :count, :id)
    voter_id = Voting.Repo.one(from x in Repository.Voter, select: x.id)

    assert number_of_voters == 1
    assert created_voter.id == voter_id
  end
end
