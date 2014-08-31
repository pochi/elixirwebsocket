defmodule Websocket do
  def handshake do
    url = to_char_list(to_string("http://localhost:8080/"))
    header_list = ['Connection': 'Upgrade',
                   'Upgrade': 'websocket',
                   'Sec-WebSocket-Key': 'change-it-later',
                   'Origin': 'http://localhost/',
                   'Sec-WebSocket-Protocol': 'change-it-later',
                   'Sec-WebSocket-Version': '13']
    headers = Enum.map header_list, fn({k,v}) -> { to_char_list(k), to_char_list(v) } end

    :ibrowse.send_req(url, headers, :get)
  end

end
