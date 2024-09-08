defmodule DesafioCli.Commands.Get do
  alias DesafioCli.State.State
  alias DesafioCli.Response.Response

  def start_get_command(args) do
    args
    |> String.split(" ")
    |> validate_set_command()
    |> handle_validate_value()
    |> IO.puts()
  end

  defp validate_set_command(list) when length(list) != 2,
    do: "ERR \"GET <chave> - Syntax error\""

  defp validate_set_command(list), do: list

  defp handle_validate_value(value) when is_bitstring(value), do: value

  defp handle_validate_value(list) do
    [_ | t] = list

    t |> to_string() |> get_value()
  end

  defp get_value(key) do
    State.current_state()
    |> Map.get(key)
    |> Response.command_get_response()
  end
end
