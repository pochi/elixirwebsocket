defmodule WebsocketTest do
  use ExUnit.Case
  import WebsocketHelpers

  @doc """
    [TODO]今はRubyで作ったWebSocketサーバ呼んでいるけどmockにしたい
  """
  test "handshake request can send" do
    { response, _ } = Websocket.handshake('localhost', 8080, '/')
    assert response == :ok
  end

  test "handshake response should receive" do
    { _, socket } = Websocket.handshake('localhost', 8080, '/')
    { status_code, data, _ } = socket |> Websocket.receive_handshake
    assert status_code == 101
    assert data == "Switching Protocols"
  end

  test "websocket can send request" do
    message = "test"
    { _, socket } = Websocket.handshake('localhost', 8080, '/')
    socket |> Websocket.receive_handshake
    socket |> Websocket.send message
    data = socket |> Websocket.recv

    assert data == 'test'
  end
end
