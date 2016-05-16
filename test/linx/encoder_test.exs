defmodule Linx.EncoderTest do
  use ExUnit.Case
  alias Linx.Encoder
  doctest Linx.Encoder

  test "encodes data" do
    data = %{
      measurement: "measurement",
      fields: %{ "field" => 1.23 },
      tags: %{ "tag" => "foo" },
      timestamp: 123_456_789
    }
    expected = "measurement,tag=foo field=1.23 123456789"
    assert Encoder.encode(data) == expected
  end
end
