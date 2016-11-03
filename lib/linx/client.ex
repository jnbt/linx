defmodule Linx.Client do
  alias Linx.{Connection,Encoder}

  def start(host, port) do
    Task.start_link(fn -> connect(host, port) end)
  end

  def write(client, data) do
    send(client, {:write, data})
    :ok
  end

  defp connect(host, port) do
    {:ok, connection} = Connection.open(host, port)
    loop_connection(connection)
  end

  defp loop_connection(connection) do
    receive do
      {:write, data} ->
        {:ok, line} = Encoder.encode(data)
        :ok = Connection.send(connection, line)
        loop_connection(connection)
    end
  end
end
