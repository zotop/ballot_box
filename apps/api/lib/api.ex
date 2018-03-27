defmodule Api do
  require Repository
  use Plug.Router

  plug Plug.Static, at: "/", from: :api
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Jason
  plug :dispatch

  get "/" do
    conn = put_resp_content_type(conn, "text/html")
    send_file(conn, 200, "priv/static/index.html")
  end

  post "/question" do
     json = conn.body_params
     question = Repository.create_question(json["question"], json["answers"])
     send_resp(conn, 201, Poison.encode!(question))
  end

  post "/vote" do
     json = conn.body_params
     result = Repository.vote(json["answer_id"])
     question_id = Map.get(result, :questions_id)
     question = Repository.get_question(question_id)
     send_resp(conn, 200, Poison.encode!(question))
  end

  match _ do
    send_resp(conn, 404, "")
  end

end
