defmodule Linx.Encoder do
  def encode(%{} = data) do
    ""
    |> encode_measurement(Map.fetch!(data, :measurement))
    |> encode_tags(Map.get(data, :tags))
    |> encode_fields(Map.fetch!(data, :fields))
    |> encode_timestamp(Map.get(data, :timestamp))
  end 

  defp encode_measurement(line, measurement) do
    line <> encode_v(measurement)
  end

  defp encode_tags(line, nil), do: line
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

  defp encode_timestamp(line, nil), do: line
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