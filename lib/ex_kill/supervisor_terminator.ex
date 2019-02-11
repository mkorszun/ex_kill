defmodule ExKill.SupervisorTerminator do
  @moduledoc """
  Periodically traverses regsitered supervision trees and kills the processes
  """
  use GenServer

  require Logger

  alias ExKill.Config

  def start_link() do
    GenServer.start_link(__MODULE__, %Config{}, name: __MODULE__)
  end

  def start_link(config, opts \\ []) do
    GenServer.start_link(__MODULE__, config, opts)
  end

  def register(supervisors) do
    GenServer.call(__MODULE__, {:register, supervisors})
  end

  @impl GenServer
  def init(config) do
    {:ok, config, config.frequency}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    Logger.info("Resolving processes to kill")

    Process.spawn(
      fn ->
        state.processes
        |> Enum.map(&get_pid/1)
        |> Enum.filter(&is_pid/1)
        |> Enum.filter(&Process.alive?/1)
        |> Enum.map(&Supervisor.which_children/1)
        |> Enum.concat()
        |> Enum.each(&traverse_and_kill(&1, state))
      end,
      []
    )

    {:noreply, state, state.frequency}
  end

  @impl GenServer
  def handle_call({:register, new_supervisors}, _, state = %Config{processes: supervisors}) do
    new_state = %Config{state | processes: Enum.concat(supervisors, new_supervisors)}
    {:reply, :ok, new_state, new_state.frequency}
  end

  defp traverse_and_kill({_, pid, :worker, _}, state) do
    kill(pid, kill?(state.probability))
  end

  defp traverse_and_kill({_, pid, :supervisor, _}, state) do
    pid
    |> Supervisor.which_children()
    |> Enum.each(&traverse_and_kill(&1, state))
  end

  defp kill(pid, _kill? = false) do
    Logger.info("Keeping process: #{inspect(Process.info(pid))}")
  end

  defp kill(pid, _kill? = true) do
    Logger.info("Killing process: #{inspect(Process.info(pid))}")
    Process.exit(pid, :kill)
  end

  defp get_pid(pid) when is_pid(pid), do: pid
  defp get_pid(name), do: Process.whereis(name)

  defp kill?(probability), do: 100 - probability <= Enum.random(0..100)
end
