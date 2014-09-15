ExUnit.start()

defmodule WebsocketHelpers do
  def response_template_direct do
     'HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: tq5n9QymbLNoW8bh+extaWBvPLk=\r\n\r\n Hello Client, you connected to /'
  end
end
