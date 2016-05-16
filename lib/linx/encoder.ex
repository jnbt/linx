defmodule Linx.Encoder do
  def encode(%{
    measurement: measurement,
    fields: fields,
    tags: tags,
    timestamp: timestamp
  }) do
    encode_v(measurement)
    <> ","
    <> encode_kv(tags)
    <> " "
    <> encode_kv(fields)
    <> " "
    <> encode_timestamp(timestamp)
  end

  defp encode_kv(%{} = data) do
    data
    |> Enum.map(fn({k,v}) -> 
      encode_v(k)
      <> "="
      <> encode_v(v)
    end)
    |> Enum.join(",")
  end

  defp encode_v(data) when is_binary(data) do
    String.replace(data, " ", ~S{\ })
  end
  defp encode_v(data) when is_integer(data) do
    "#{data}i"
  end
  defp encode_v(data) do
    to_string(data)
  end

  defp encode_timestamp(data) when is_integer(data) do
    to_string(data)
  end
end