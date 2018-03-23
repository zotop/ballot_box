defmodule RepositoryTest do
  import Ecto.Query, only: [from: 2]
  use ExUnit.Case

  doctest Repository

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Voting.Repo)
  end

  test "create a voter" do
    created_voter = Repository.create_voter()
    number_of_voters = Voting.Repo.aggregate(Repository.Voters, :count, :id)
    voter_id = Voting.Repo.one(from(x in Repository.Voters, select: x.id))

    assert number_of_voters == 1
    assert created_voter.id == voter_id
  end

  test "voting for an answer should increment number of votes" do
    question = "What is my name?"
    answers = ["John", "Julia"]
    created_question = Repository.create_question(question, answers)
    answer_id = Enum.at(created_question.answers, 0).id
    voter_1 = Repository.create_voter()
    voter_2 = Repository.create_voter()
    Repository.vote!(voter_1.id, answer_id)
    Repository.vote!(voter_2.id, answer_id)

    vote_count =
      Voting.Repo.one(
        from(
          x in Repository.Answers,
          where: x.id == ^answer_id,
          select: x.votes
        )
      )

    assert vote_count == 2
  end

  test "a not found voter cannot vote" do
    question = "What is my name?"
    answers = ["John", "Julia"]
    created_question = Repository.create_question(question, answers)
    answer_id = Enum.at(created_question.answers, 0).id

    assert_raise Ecto.NoResultsError, fn ->
      Repository.vote!(Ecto.UUID.generate(), answer_id)
    end

    vote_count =
      Voting.Repo.one(
        from(
          x in Repository.Answers,
          where: x.id == ^answer_id,
          select: x.votes
        )
      )

    assert vote_count == 0
  end
end
