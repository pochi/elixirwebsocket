defmodule Frame do
  def to_frame(tcp_data) do
    case tcp_data do
      { :ok, data } when data |> is_list ->
        [129 | data] = data
        [4 | text] = data
    end
    text
  end

  def text_frame(text) do
    opcode = [ text: 0x1, binary: 0x2, close: 0x8, ping: 0x9, pong: 0xA ]
    message = << 0 :: 1, << byte_size(text) :: 7 >> :: bitstring, text :: bitstring >>
    << 1 :: 1,
       0 :: 3,
       opcode[:text] :: 4,
       message  :: binary >>
  end
end