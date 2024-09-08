defmodule DesafioCli do
  alias Commands.Set
  alias DesafioCli.State.State
  alias DesafioCli.Commands.{Set, Get}

  @moduledoc """
  Ponto de entrada para a CLI.
  """

  @doc """
  A função main recebe os argumentos passados na linha de
  comando como lista de strings e executa a CLI.
  """
  def main(_args) do
    State.start_link()

    IO.gets(">")
    |> String.trim()
    |> String.replace(~r/\\|\"/, "")
    |> handle_input()
    |> main()
  end

  def handle_input(args) do
    cond do
      args |> String.upcase() |> String.contains?("SET") -> Set.start_set_command(args)
      args |> String.upcase() |> String.contains?("GET") -> Get.start_get_command(args)
      true -> IO.puts("ERR \"No command #{args}\"")
    end
  end
end
