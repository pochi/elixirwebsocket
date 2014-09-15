defmodule Websocket do

  @spec handshake :: tuple
  def handshake do
    address = 'localhost'
    port = 8080
    origin = 'http://localhost/'
    key = :base64.encode("some websocket key")

    { :ok, socket } = :gen_tcp.connect(address, port, [], :infinity)
    socket |> :inet.setopts(active: true, packet: :raw)

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

    response = socket |> :gen_tcp.send(handshake_message)
    { response, socket }
  end

  def loop_acceptor(client) do
    # activeモードから変更しないとrecvが呼び出せない
    # activeモードのままだと { :error, :einval }がかえってくる
    client |> :inet.setopts(active: false, packet: :http_bin)
    { :ok, { :http_response, _, status_code, switch_message } } = client |> :gen_tcp.recv(0)
    http_headers = client |> headers
    { status_code, switch_message, http_headers }
  end

  def ping(client) do
    client |> :inet.setopts(active: true, packet: :raw)
    response = client |> :gen_tcp.send("pingpingping")
    { response, client }
  end

  defp headers(client) do
    headers([], client)
  end

  defp headers(http_header, client) do
    case client |> :gen_tcp.recv(0) do
      {:ok, {:http_header, _, name, _, val } } ->
         http_header ++ [{name, val}] |> headers(client)
      {:ok, :http_eoh } ->
         http_header
    end

  end

end
