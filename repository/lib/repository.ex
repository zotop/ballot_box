defmodule Repository do
  @moduledoc """
  Documentation for Repository.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Repository.hello
      :world

  """
  def hello do
    :world
  end

  def create_question(question, answers) do
    answers = Enum.map(answers, fn(answer) -> %{answer: answer} end)
    question = Ecto.Changeset.change(%Repository.Question{}, question: question, answer: answers)
    Voting.Repo.insert!(question)
    #TODO: transaction so that we also initialize the vote table
  end

  def create_voter do
    Voting.Repo.insert!(%Repository.Voter{})
  end

  def vote!(voter_id, answer_id) do
    IO.inspect("YOOOOOO")
    answer_to_vote_for = Voting.Repo.get_by!(Repository.Vote, answer_id: answer_id)
    #IO.inspect(answer_to_vote_for)
    #.update!(change(alice, balance: alice.balance - 10))
  end


end
