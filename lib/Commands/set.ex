defmodule DesafioCli.Commands.Set do
  alias DesafioCli.Response.Response
  alias DesafioCli.State.State

  def start_set_command(args) do
    args
    |> String.split(" ")
    |> validate_set_command()
    |> handle_validate_value()
    |> IO.puts()
  end

  defp validate_set_command(list) when length(list) < 3,
    do: "ERR \"SET <chave> <valor> - Syntax error\""

  defp validate_set_command(list), do: list

  defp handle_validate_value(value) when is_bitstring(value), do: value

  defp handle_validate_value(list) do
    [h | t] = tl(list)

    t
    |> handle_value()
    |> set_value(h)
  end

  def get_value(state, key) do
    state
    |> Map.get(key)
  end

  defp set_value(value, key) do
    State.current_state()
    |> verify_key_exists(key)
    |> update_state(key, value)
  end

  defp update_state(map, key, value) when is_nil(map) do
    State.current_state()
    |> Map.put(key, value)
    |> State.update_state()

    Response.command_set_response(nil, value)
  end

  defp update_state(_, key, value) do
    State.current_state()
    |> Map.put(key, value)
    |> State.update_state()
    |> Response.command_set_response(value)
  end

  defp verify_key_exists(state, key) do
    state |> get_value(key)
  end

  defp handle_value(value) do
    value |> handle_type()
  end

  defp handle_type(value) do
    [:bool, :integer, :string]
    |> handle_type(value)
  end

  defp handle_type(list, value) when length(list) == 0, do: value

  defp handle_type(list, value) do
    [h | t] = list
    define_type(h, value, t)
  end

  defp define_type(type, value, t) do
    type({type, value}, t)
  end

  defp type({:bool, value}, t) do
    if String.to_atom(to_string(value)) |> is_boolean() do
      value
      |> to_string()
      |> String.to_atom()
    else
      handle_type(t, value)
    end
  end

  defp type({:integer, value}, t) do
    try do
      value
      |> to_string()
      |> String.to_integer()
    rescue
      _ -> handle_type(t, value)
    end
  end

  defp type({:string, value}, _), do: value
end
