defmodule Linx.Connection do
  def send(host, port, line) do
    {:ok, socket} = :gen_udp.open(0)
    :ok = :gen_udp.send(socket, to_erl(host), port, to_erl(line))
  end

  defp to_erl(data) when is_list(data), do: data
  defp to_erl(data) when is_binary(data) do
    String.to_char_list(data)
  end
end