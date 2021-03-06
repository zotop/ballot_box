defmodule Api do
  require Repository
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Static, at: "/", from: :api
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  get "/" do
    conn = put_resp_content_type(conn, "text/html")
    send_file(conn, 200, "priv/static/index.html")
  end

  get "/api/questions" do
    questions = Repository.get_all_questions()
    send_resp(conn, 200, Poison.encode!(questions))
  end

  get "/api/questions/:question_id" do
    question_id = conn.params["question_id"]
    questions = Repository.get_question(question_id)
    send_resp(conn, 200, Poison.encode!(questions))
  end

  post "/api/questions" do
     json = conn.body_params
     question = Repository.create_question(json["question"], json["answers"])
     send_resp(conn, 201, Poison.encode!(question))
  end

  post "/api/questions/vote" do
     json = conn.body_params
     result = Repository.vote(json["answer_id"])
     question_id = Map.get(result, :questions_id)
     question = Repository.get_question(question_id)
     send_resp(conn, 200, Poison.encode!(question))
  end

  match _ do
    send_resp(conn, 404, "")
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    IO.inspect(conn)
    send_resp(conn, conn.status, "Something went wrong")
  end

end
