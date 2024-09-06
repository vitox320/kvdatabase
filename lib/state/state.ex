defmodule DesafioCli.State do
  use Agent

  def start_link() do
    Agent.start(fn -> %{} end, name: __MODULE__)
  end

  def current_state() do
    Agent.get(__MODULE__, & &1)
  end

  def update_state(value) do
    Agent.update(__MODULE__, fn _ -> value end)
  end
end
