defmodule DesafioCli.Response.Response do
  def command_set_response(registered_value, value) when registered_value |> is_nil(),
    do: "FALSE #{value}"

  def command_set_response(_, value), do: "TRUE #{value}"

  def command_get_response(value) when value |> is_nil(), do: "NIL"

  def command_get_response(value), do: value
end
