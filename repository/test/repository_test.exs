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

  test "should be able to insert a question with answers" do
    question = "What is my name?"
    answers = ["John", "Julia"]
    created_question = Repository.create_question(question, answers)
    answer_1 = Enum.at(created_question.answer, 0).answer
    answer_2 = Enum.at(created_question.answer, 1).answer
    votes_answer_1 = Enum.at(created_question.answer, 0).votes
    votes_answer_2 = Enum.at(created_question.answer, 1).votes

    assert created_question.question == question
    assert length(created_question.answer) == 2
    assert answers -- [answer_1, answer_2] == []
    assert votes_answer_1 == 0
    assert votes_answer_2 == 0
  end

  test "create a voter" do
    created_voter = Repository.create_voter()
    number_of_voters = Voting.Repo.aggregate(Repository.Voter, :count, :id)
    voter_id = Voting.Repo.one(from x in Repository.Voter, select: x.id)

    assert number_of_voters == 1
    assert created_voter.id == voter_id
  end

  test "voting for an answer should increment number of votes" do
    question = "What is my name?"
    answers = ["John", "Julia"]
    created_question = Repository.create_question(question, answers)
    answer_id = Enum.at(created_question.answer, 0).id
    voter_1 = Repository.create_voter()
    voter_2 = Repository.create_voter()
    Repository.vote!(voter_1.id, answer_id)
    Repository.vote!(voter_2.id, answer_id)

    vote_count = Voting.Repo.one(from x in Repository.Answer,
                                 where: x.id == ^answer_id,
                                 select: x.votes)

    assert vote_count == 2                            

  end
end
