defmodule WebsocketTest do
  use ExUnit.Case
  import WebsocketHelpers

  @doc """
    [TODO]今はRubyで作ったWebSocketサーバ呼んでいるけどmockにしたい
  """
  test "handshake request can send" do
    { response, _socket } = Websocket.handshake
    assert response == :ok
  end

  test "handshake response should receive" do
    { _, socket } = Websocket.handshake
    { status_code, data, _ } = Websocket.receive_handshake(socket)
    assert status_code == 101
    assert data == "Switching Protocols"
  end

  test "websocket can send request" do
    { _, socket } = Websocket.handshake
    Websocket.receive_handshake(socket)
    Websocket.send(socket)
    data = Websocket.recv(socket)

    assert data == 'test'
  end
end
