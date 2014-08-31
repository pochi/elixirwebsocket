defmodule Websocket do
  def handshake do
    address = String.to_char_list("localhost")
    port = String.to_integer("8080")
    origin = "http://localhost/"
    key = :base64.encode("some websocket key")

    { :ok, socket } = :gen_tcp.connect(address, port, [], :infinity)

    handshake_message = [
      "GET / HTTP/1.1", "\r\n",
      "Host: #{address}:#{port}", "\r\n",
      "Origin: #{origin}", "\r\n",
      "Upgrade: websocket", "\r\n",
      "Connection: Upgrade", "\r\n",
      "Sec-WebSocket-Key: #{key}", "\r\n",
      "Sec-WebSocket-Version: 13", "\r\n",
      "\r\n",
    ]

    :gen_tcp.send(socket, handshake_message)
  end


end
