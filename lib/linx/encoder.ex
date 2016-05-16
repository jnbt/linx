defmodule Linx.Encoder do
  def encode(%{
    measurement: measurement,
    fields: fields,
    tags: tags,
    timestamp: timestamp
  }) do
    [
      measurement,
      ",",
      encode_kv(tags),
      " ",
      encode_kv(fields),
      " ",
      timestamp
    ] |> Enum.join
  end

  defp encode_kv(%{} = data) do
    data
    |> Enum.map(fn({k,v}) -> "#{k}=#{v}" end)
    |> Enum.join(",")
  end
end