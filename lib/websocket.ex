defmodule Websocket do
  import Frame
  alias __MODULE__, as: W

  def start(websocket_group) do
    { _, client } = W.handshake(websocket_group)
    client |> receive_handshake
    receive do
      {sender, message} ->
        IO.puts message
    end
  end

  @spec handshake(websocket_group :: WebsocketGroup) :: tuple
  def handshake(websocket_group) do
    W.handshake(websocket_group.host, websocket_group.port, websocket_group.path)
  end

  @spec handshake(address :: String, port :: Integer, path :: String) :: tuple
  def handshake(address, port, path) do
    origin = 'http://' ++ address
    key = key("some websocket key")

    # :infinity means wait time for connect.
    { :ok, socket } = :gen_tcp.connect(address, port, [], :infinity)
    socket |> :inet.setopts(active: true, packet: :raw)
    response = socket |> :gen_tcp.send(handshake_request(address, port, path, origin, key))
    { response, socket }
  end

  @doc """
    activeモードから変更しないとrecvが呼び出せない
    activeモードのままだと { :error, :einval }がかえってくる
  """
  def receive_handshake(client) do
    client |> :inet.setopts(active: false, packet: :http_bin)
    { :ok, { :http_response, _, status_code, switch_message } } = client |> :gen_tcp.recv(0)
    http_headers = client |> headers
    { status_code, switch_message, http_headers }
  end

  def send(client, text) do
    client |> :inet.setopts(active: true, packet: :raw)
    client |> :gen_tcp.send(text_frame(text))
  end

  def recv(client) do
    client |> :inet.setopts(active: false, packet: :raw)
    client |> :gen_tcp.recv(0) |> to_frame
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

  @spec key(value :: String) :: String
  defp key(value) do
    :crypto.hash(:sha, value <> "258EAFA5-E914-47DA-95CA-C5AB0DC85B11") |> :base64.encode
  end

end
