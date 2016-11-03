defmodule Linx.ClientTest do
  use ExUnit.Case
  alias Linx.Client
  doctest Linx

  setup do
    {:ok, server} = :gen_udp.open(0, [:binary, active: false])
    {:ok, port} = :inet.port(server)
    [server: server, port: port]
  end

  test "writes a single series to socket", context do
    {:ok, client} = Client.start("localhost", context[:port])
    :ok = Client.write(client, %{:measurement => "m", :fields => %{ a: 1.0 }})

    {:ok, {_, _, "m a=1.0"}} = :gen_udp.recv(context[:server], 0)
  end
end
