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
    expected = ~S{measurement,tag=foo field=1.23 123456789}
    assert Encoder.encode(data) == expected
  end

  test "escapes whitespaces" do
    data = %{
      measurement: "A test measurement",
      fields: %{ "some long field" => 5 },
      tags: %{ "some tag" => "with whitespace" },
      timestamp: 123_456_789
    }
    expected = ~S{A\ test\ measurement,some\ tag=with\ whitespace some\ long\ field=5i 123456789}

    assert Encoder.encode(data) == expected
  end

  test "escapes commas" do
    data = %{
      measurement: "A,test,measurement",
      fields: %{ "some,long,field" => 5 },
      tags: %{ "some,tag" => "with,comma" },
      timestamp: 123_456_789
    }
    expected = ~S{A\,test\,measurement,some\,tag=with\,comma some\,long\,field=5i 123456789}

    assert Encoder.encode(data) == expected
  end
end
