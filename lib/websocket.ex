defmodule Websocket do
  def handshake do
    url = to_char_list(to_string("http://localhost:8080/"))
    :ibrowse.send_req(url, [], :get)
  end

end
