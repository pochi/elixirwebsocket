defmodule Frame do
  def to_frame(tcp_data) do
    case tcp_data do
      { :ok, data } when data |> is_list ->
        [129 | data] = data
        [4 | text] = data
    end
    text
  end
end