defmodule Api do
  require Repository
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Jason
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  post "/question" do
     json = conn.body_params
     Repository.create_question(json["question"], json["answers"])
     send_resp(conn, 201, "")
  end

  match _ do
    send_resp(conn, 404, "")
  end

end
