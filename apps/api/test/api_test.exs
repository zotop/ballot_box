defmodule ApiTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Api.init([])

  test "returns created question with answers" do
    question = "What is your name?"
    answers = ["John", "Julia"]
    conn = conn(:post, "/question",  %{question: question, answers: answers})
    |> put_req_header("content-type", "application/json")
    |> Api.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    #assert conn.resp_body == "world"
  end
end
