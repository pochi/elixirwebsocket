defmodule WebsocketGroup do
  defstruct host: 'localhost', port: 8080, path: '/'

  def create(websocket_group, client_num) do
    {:ok, Enum.map(1..client_num, fn(num) ->
      spawn(Websocket, :start, [%WebsocketGroup{}])
    end) }
  end
end
