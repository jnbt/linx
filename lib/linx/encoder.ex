defmodule Linx.Encoder do
  def encode(%{} = data) do
    do_encode(data)
  end

  defp do_encode(%{
    measurement: measurement,
    fields: fields,
    tags: tags,
    timestamp: timestamp
  }) do
    ""
    |> encode_measurement(measurement)
    |> encode_tags(tags)
    |> encode_fields(fields)
    |> encode_timestamp(timestamp)
  end 

  defp do_encode(%{
    measurement: measurement,
    fields: fields
  }) do
    ""
    |> encode_measurement(measurement)
    |> encode_fields(fields)
  end 

  defp encode_measurement(line, measurement) do
    line <> encode_v(measurement)
  end

  defp encode_tags(line, %{} = tags) do
    line
    <> ","
    <> encode_kv(tags)
  end

  defp encode_fields(line, %{} = fields) do
    line
    <> " "
    <> encode_kv(fields)
  end

  defp encode_timestamp(line, timestamp) when is_integer(timestamp) do
    line
    <> " "
    <> to_string(timestamp)
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
    data
    |> String.replace(" ", ~S{\ })
    |> String.replace(",", ~S{\,})
    |> String.replace("\"", ~S{\"})
  end
  defp encode_v(data) when is_integer(data) do
    "#{data}i"
  end
  defp encode_v(data) do
    to_string(data)
  end
end