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

  def get_question(question_id) do
    Voting.Repo.get(Repository.Questions, question_id)
    |> Voting.Repo.preload([:answers])
  end

  def vote(answer_id) do
    answer_to_vote_for = Voting.Repo.get_by!(Repository.Answers, id: answer_id)
    answer_to_vote_for = Ecto.Changeset.change(answer_to_vote_for, votes: answer_to_vote_for.votes + 1)
    Voting.Repo.update!(answer_to_vote_for)
  end
end
