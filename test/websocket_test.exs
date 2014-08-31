defmodule WebsocketTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "handshake request can send" do
    response = Websocket.handshake
    assert response == :ok
  end
end
