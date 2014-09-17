defmodule Websocket do

  @spec handshake(address :: String, port :: Integer, path :: String) :: tuple
  def handshake(address, port, path) do
    origin = 'http://' ++ address
    key = key("some websocket key")

    # :infinityは接続待ちの時間
    { :ok, socket } = :gen_tcp.connect(address, port, [], :infinity)
    socket |> :inet.setopts(active: true, packet: :raw)
    response = socket |> :gen_tcp.send(handshake_request(address, port, path, origin, key))
    { response, socket }
  end

  def receive_handshake(client) do
    # activeモードから変更しないとrecvが呼び出せない
    # activeモードのままだと { :error, :einval }がかえってくる
    client |> :inet.setopts(active: false, packet: :http_bin)
    { :ok, { :http_response, _, status_code, switch_message } } = client |> :gen_tcp.recv(0)
    http_headers = client |> headers
    { status_code, switch_message, http_headers }
  end

  @doc """
    [TODO]  Frameクラスに移行する
  """
  def send(client, text) do
    client |> :inet.setopts(active: true, packet: :raw)
    opcode = [ text: 0x1, binary: 0x2, close: 0x8, ping: 0x9, pong: 0xA ]
    message = << 0 :: 1, << byte_size(text) :: 7 >> :: bitstring, text :: bitstring >>
    send_message = << 1 :: 1,
                      0 :: 3,
                      opcode[:text] :: 4,
                      message  :: binary >>
    client |> :gen_tcp.send(send_message)
  end

  def recv(client) do
    client |> :inet.setopts(active: false, packet: :raw)
    client |> :gen_tcp.recv(0) |> Frame.to_frame
  end

  defp headers(client) do
    headers([], client)
  end

  defp headers(http_headers, client) do
    client |> :inet.setopts(active: false, packet: :http_bin)
    case client |> :gen_tcp.recv(0) do
      {:ok, {:http_header, _, name, _, val } } ->
         http_headers ++ [{name, val}] |> headers(client)
      {:ok, :http_eoh } ->
         http_headers
    end
  end

  defp handshake_request(address, port, path, origin, key) do
    [
      "GET #{path} HTTP/1.1", "\r\n",
      "Host: #{address}:#{port}", "\r\n",
      "Origin: #{origin}", "\r\n",
      "Upgrade: websocket", "\r\n",
      "Connection: Upgrade", "\r\n",
      "Sec-WebSocket-Key: #{key}", "\r\n",
      "Sec-WebSocket-Version: 13", "\r\n",
      "\r\n",
    ]
  end

  @spec key(String.t) :: String.t
  defp key(value) do
    :crypto.hash(:sha, value <> "258EAFA5-E914-47DA-95CA-C5AB0DC85B11") |> :base64.encode
  end

end
