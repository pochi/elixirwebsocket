defmodule Websocket do
  def handshake do
    address = String.to_char_list("localhost")
    port = String.to_integer("8080")
    origin = "http://localhost/"
    key = :base64.encode("some websocket key")

    { :ok, socket } = :gen_tcp.connect(address, port, [], :infinity)
    :inet.setopts(socket, packet: :raw)

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

    response = :gen_tcp.send(socket, handshake_message)
    { response, socket }
  end

  def loop_acceptor(socket) do
    # activeモードから変更しないとrecvが呼び出せない
    # activeモードのままだと { :error, :einval }がかえってくる
    :inet.setopts(socket, active: false)
    :gen_tcp.recv(socket, 0)
  end

end
