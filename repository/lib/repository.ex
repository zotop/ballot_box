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
  end

  def create_voter do
    Voting.Repo.insert!(%Repository.Voter{})
  end

end
