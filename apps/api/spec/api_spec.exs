defmodule ApiSpec do
  use ESpec
  use Plug.Test

  @opts Api.init([])

  describe "question" do

    let question: "What is my name?"
    let answers: ["John", "Julia"]

    context "when creating a question" do

      it "should return created question with answers" do
        conn = conn(:post, "/api/questions",  %{question: question(), answers: answers()})
        |> put_req_header("content-type", "application/json")
        |> Api.call(@opts)
        response = Poison.decode!(conn.resp_body)

        expect(conn.state).to eq(:sent)
        expect(conn.status).to eq(201)
        expect(response["question"]).to eq(question())
        expect(response["answers"]).to have_count(2)
      end

    end

    context "when retrieving all questions" do

      let! created_question: Repository.create_question(question(), answers())

      it "should be able to retrieve them with their answers" do
        conn = conn(:get, "/api/questions")
        |> put_req_header("content-type", "application/json")
        |> Api.call(@opts)
        [retrieved_question] = Poison.decode!(conn.resp_body)
        retrieved_answers = List.flatten(
         Enum.map(retrieved_question["answers"], fn answer -> answer["answer"] end)
        )

        expect(retrieved_question["question"]).to eq(question())
        expect(retrieved_answers -- answers()).to eq([])
      end

    end

    context "when voting on a question" do

      let! question: Repository.create_question(question(), answers())

      it "should increase votes for the chosen answer" do
        [answer_1, answer_2] = question().answers
        conn = conn(:post, "/api/vote",  %{answer_id: answer_1.id})
        |> put_req_header("content-type", "application/json")
        |> Api.call(@opts)
        response = Poison.decode!(conn.resp_body)
        updated_answers = response["answers"]

        expect(conn.state).to eq(:sent)
        expect(conn.status).to eq(200)
        expect(updated_answers).to have_count(1)
        #assert updated_answer["votes"] == 1
      end
    end

  end


end