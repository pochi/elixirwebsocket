defmodule WebsocketGroupTest do
  use ExUnit.Case

  test "it should be create group" do
    { :ok, pids } = %WebsocketGroup{} |> WebsocketGroup.create(1000)
    assert length(pids) == 1000
  end

  test "it should has 'host' column" do
    websocket_group = %WebsocketGroup{}
    assert websocket_group.host == 'localhost'
  end

  test "it should has 'port' column" do
    websocket_group = %WebsocketGroup{}
    assert websocket_group.port == 8080
  end

  test "it should has 'path' column" do
    websocket_group = %WebsocketGroup{}
    assert websocket_group.path == '/'
  end
end
