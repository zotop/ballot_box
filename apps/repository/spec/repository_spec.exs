defmodule RepositorySpec do
  import Ecto.Query, only: [from: 2]
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

  context "when creating a voter" do

    let! created_voter: Repository.create_voter()

    it "should generate an UUID" do
      number_of_voters = Voting.Repo.aggregate(Repository.Voters, :count, :id)
      voter_id = Voting.Repo.one(from(x in Repository.Voters, select: x.id))

      expect(number_of_voters).to be(1)
      expect(created_voter.id).to eq(voter_id)
    end

  end

  context "when voting for an answer" do

    let question: "What is my name?"
    let answers: ["John", "Julia"]
    let! created_question: Repository.create_question(question, answers)
    let answer_id: Enum.at(created_question.answers, 0).id

    context "and voter is not registered" do

      it "should raise an error and not " do
        voting = fn -> Repository.vote(Ecto.UUID.generate(), answer_id) end

        expect voting |> to(raise_exception())
      end

      it "should not increment the votes for the answer" do
        try do
          Repository.vote(Ecto.UUID.generate(), answer_id)
        rescue e ->
          vote_count =
            Voting.Repo.one(
              from(
                x in Repository.Answers,
                where: x.id == ^answer_id,
                select: x.votes
              )
            )
          expect(vote_count).to be(0)
        end
      end

    end

    context "with valid voters" do

      let! voter_1: Repository.create_voter()
      let! voter_2: Repository.create_voter()

      it "should increment the number of votes for the answer" do
        Repository.vote(voter_1.id, answer_id)
        Repository.vote(voter_2.id, answer_id)
        vote_count =
          Voting.Repo.one(
            from(
              x in Repository.Answers,
              where: x.id == ^answer_id,
              select: x.votes
            )
          )

        expect(vote_count).to be(2)
      end

    end

  end

end
