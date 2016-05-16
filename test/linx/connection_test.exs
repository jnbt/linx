defmodule Linx.ConnectionTest do
  use ExUnit.Case
  alias Linx.{Connection}
  doctest Linx.Connection

  test "sends a line using UDP" do
    {:ok, server} = :gen_udp.open(0, [:binary, active: false])
    {:ok, server_port} = :inet.port(server)

    {:ok, connection} = Connection.open("localhost", server_port)
    :ok = Connection.send(connection, "Hello World")

    {:ok, {_, _, "Hello World"}} = :gen_udp.recv(server, 0)
  end
end