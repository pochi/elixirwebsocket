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
    { response, data } = Websocket.loop_acceptor(socket)
    assert data == response_template_direct
  end

end
