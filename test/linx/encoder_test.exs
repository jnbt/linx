defmodule Linx.EncoderTest do
  use ExUnit.Case
  alias Linx.{Encoder,Data}
  doctest Linx.Encoder

  test "does not support unknown data types" do
    {:error, _} = Encoder.encode(nil)
    {:error, _} = Encoder.encode(1)
    {:error, _} = Encoder.encode("")
    {:error, _} = Encoder.encode(<<1>>)
    {:error, _} = Encoder.encode([])

    assert_raise MatchError, fn -> 
      Encoder.encode!(nil)
    end
  end

  test "encodes data" do
    data = %{
      measurement: "measurement",
      fields: %{ "field" => 1.23 },
      tags: %{ "tag" => "foo" },
      timestamp: 123_456_789
    }
    expected = ~S{measurement,tag=foo field=1.23 123456789}
    assert_encoded(data, expected)
  end

  test "escapes whitespaces" do
    data = %{
      measurement: "A test measurement",
      fields: %{ "some long field" => 5.0 },
      tags: %{ "some tag" => "with whitespace" },
      timestamp: 123_456_789
    }
    expected = ~S{A\ test\ measurement,some\ tag=with\ whitespace some\ long\ field=5.0 123456789}

    assert_encoded(data, expected)
  end

  test "escapes commas" do
    data = %{
      measurement: "A,test,measurement",
      fields: %{ "some,long,field" => 5.0 },
      tags: %{ "some,tag" => "with,comma" },
      timestamp: 123_456_789
    }
    expected = ~S{A\,test\,measurement,some\,tag=with\,comma some\,long\,field=5.0 123456789}

    assert_encoded(data, expected)
  end

  test "escapes quotes" do
    data = %{
      measurement: "A\"test\"measurement",
      fields: %{ "some\"long\"field" => 5.0 },
      tags: %{ "some\"tag" => "with\"comma" },
      timestamp: 123_456_789
    }
    expected = ~S{A\"test\"measurement,some\"tag=with\"comma some\"long\"field=5.0 123456789}

    assert_encoded(data, expected)
  end

  test "encodes minimum data" do
    data = %{
      measurement: "series",
      fields: %{ "field" => 0.51 }
    }
    expected = ~S{series field=0.51}

    assert_encoded(data, expected)
    assert expected == Encoder.encode!(data)
  end

  test "encodes from Data struct" do
    data = %Data{
      measurement: "series",
      fields: %{ "field" => 0.51 }
    }
    expected = ~S{series field=0.51}

    assert_encoded(data, expected)
  end

  test "encodes with tags" do
    data = %{
      measurement: "series",
      tags: %{ "foo" => "bar" },
      fields: %{ "field" => 0.51 }
    }
    expected = ~S{series,foo=bar field=0.51}

    assert_encoded(data, expected)
  end

  test "encodes with timestamp" do
    data = %{
      measurement: "series",
      fields: %{ "field" => 0.51 },
      timestamp: 123_456_789
    }
    expected = ~S{series field=0.51 123456789}

    assert_encoded(data, expected)
  end

  test "encodes for integer values" do
    data = %{
      measurement: "series",
      fields: %{ "field" => 5 }
    }
    expected = ~S{series field=5i}

    assert_encoded(data, expected)
  end

  test "encodes for boolean values" do
    data = %{
      measurement: "series",
      fields: %{ "one" => true, "two" => false}
    }
    expected = ~S{series one=true,two=false}

    assert_encoded(data, expected)
  end

  defp assert_encoded(data, expected) do
    assert {:ok, expected} == Encoder.encode(data)
  end
end
