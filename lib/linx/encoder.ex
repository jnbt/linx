defmodule Linx.Data do
  defstruct measurement: nil, tags: nil, fields: nil, timestamp: nil  
end

defmodule Linx.Encoder do
  alias Linx.Data

  def encode(%Data{} = data) do
    {:ok, do_encode(data)}
  end
  def encode(%{} = data) do
    {:ok, do_encode(struct(Data, data))}
  end
  def encode(_) do
    {:error, "Cannot encode passed data. Pass Linx.Data or Map."}
  end

  def encode!(data) do
    {:ok, line} = encode(data)
    line
  end

  defp do_encode(%Data{
    measurement: measurement,
    tags: tags,
    fields: fields,
    timestamp: timestamp
  }) 
  when is_binary(measurement) and is_map(fields)
  do
    ""
    |> encode_measurement(measurement)
    |> encode_tags(tags)
    |> encode_fields(fields)
    |> encode_timestamp(timestamp)
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