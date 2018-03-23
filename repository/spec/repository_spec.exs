defmodule RepositorySpec do
  use ESpec

  before_all do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Voting.Repo)
  end

  context "when creating a question" do

    let question: "What is my name?"
    let answers: ["John", "Julia"]
    let! created_question: Repository.create_question(question, answers)
    let created_answers: created_question.answers

    it "should create question with possible answers" do
      [answer_1, answer_2] = created_answers

      expect(created_question.question).to eq(question)
      expect(length(created_answers)).to eq(2)
      expect(answers -- [answer_1.answer, answer_2.answer]).to eq([])
    end

    it "should initialize answers with 0 votes" do
      [answer_1, answer_2] = created_answers

      expect([answer_1.votes, answer_2.votes]).to eq([0, 0])
    end

  end

end
