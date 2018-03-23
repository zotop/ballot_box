defmodule Repository do
  @moduledoc """
  Documentation for Repository.
  """

  def create_question(question, answers) do
    answers = Enum.map(answers, fn answer -> %{answer: answer, votes: 0} end)

    question =
      Ecto.Changeset.change(%Repository.Questions{}, question: question, answers: answers)

    Voting.Repo.insert!(question)
  end

  def create_voter do
    Voting.Repo.insert!(%Repository.Voters{})
  end

  # TODO: a voter should not be able to vote twice in the same question
  def vote!(voter_id, answer_id) do
    Voting.Repo.get_by!(Repository.Voters, id: voter_id)
    answer_to_vote_for = Voting.Repo.get_by!(Repository.Answers, id: answer_id)

    answer_to_vote_for =
      Ecto.Changeset.change(answer_to_vote_for, votes: answer_to_vote_for.votes + 1)

    Voting.Repo.update!(answer_to_vote_for)
  end
end
