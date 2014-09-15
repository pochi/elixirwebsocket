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
    { status_code, data, _ } = Websocket.loop_acceptor(socket)
    assert status_code == 101
    assert data == "Switching Protocols"
  end

  test "socket can send ping request" do
    { _, socket } = Websocket.handshake
    { _, _, _ } = Websocket.loop_acceptor(socket)
    { response, _ } = Websocket.ping(socket)
    assert response == :ok
  end

end
