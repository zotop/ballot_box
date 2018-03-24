defmodule ApiTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Api.init([])

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Voting.Repo)
  end

  test "returns created question with answers" do
    question = "What is your name?"
    answers = ["John", "Julia"]
    conn = conn(:post, "/question",  %{question: question, answers: answers})
    |> put_req_header("content-type", "application/json")
    |> Api.call(@opts)
    response = Poison.decode!(conn.resp_body)

    assert conn.state == :sent
    assert conn.status == 201
    assert response["question"] == question
    assert length(response["answers"]) == 2
  end
end
