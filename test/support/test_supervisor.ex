defmodule TestSupervisor do
  @moduledoc false
  use DynamicSupervisor

  @child_spec %{
    id: TestWorker,
    restart: :permanent,
    type: :worker,
    start: {TestWorker, :start_link, []}
  }

  def start(name, worker_count \\ 10, custom_config \\ []) do
    Process.flag(:trap_exit, true)

    with {:ok, pid} <- DynamicSupervisor.start_link(__MODULE__, custom_config, name: name),
         :ok <- start_workers(pid, worker_count) do
      {:ok, pid}
    end
  end

  @impl DynamicSupervisor
  def init(custom_config) do
    default_config = [strategy: :one_for_one, max_restarts: 100, max_seconds: 5]
    DynamicSupervisor.init(Keyword.merge(default_config, custom_config))
  end

  defp start_workers(supervisor, count) do
    1..count
    |> Enum.each(fn _ -> DynamicSupervisor.start_child(supervisor, @child_spec) end)

    :ok
  end
end
