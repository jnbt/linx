defmodule Linx.Connection do
  defstruct [:host, :port, :socket]

  def open(host, port) do
    {:ok, socket} = :gen_udp.open(0)
    connection = %__MODULE__{
      host: to_erl(host), 
      port: port, 
      socket: socket
    }
    {:ok, connection}
  end

  def send(%{host: host, port: port, socket: socket}, line) do
    :gen_udp.send(socket, host, port, to_erl(line))
  end

  defp to_erl(data) when is_list(data), do: data
  defp to_erl(data) when is_binary(data) do
    String.to_char_list(data)
  end
end