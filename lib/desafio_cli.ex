defmodule DesafioCli do
  @moduledoc """
  Ponto de entrada para a CLI.
  """

  @doc """
  A função main recebe os argumentos passados na linha de
  comando como lista de strings e executa a CLI.
  """
  def main(_args) do
    IO.gets(">")
    |> String.trim()
    |> handle_input()
    |> main()
  end

  def handle_input(args) do
    cond do
      args |> String.contains?("SET") -> handle_set_command(args)
      true -> IO.puts("ERR \"No command #{args}\"")
    end
  end

  defp handle_set_command(args) do
    args
    |> String.split(" ")
    |> validate_set_command()
    |> handle_validate_value()
    |> IO.puts()
  end

  defp validate_set_command(list) when length(list) < 3,
    do: "ERR \"SET <chave> <valor> - Syntax error\""

  defp validate_set_command(list), do: list

  defp handle_validate_value(list) do
    [_ | t] = tl(list)
    t |> handle_value()
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
