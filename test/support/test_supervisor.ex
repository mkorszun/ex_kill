defmodule TestSupervisor do
  use DynamicSupervisor

  @child_spec %{
    id: TestWorker,
    restart: :permanent,
    type: :worker,
    start: {TestWorker, :start_link, []}
  }

  def start(name, worker_count \\ 10) do
    Process.flag(:trap_exit, true)

    with {:ok, pid} <- DynamicSupervisor.start_link(__MODULE__, :ok, name: name),
         :ok <- start_workers(pid, worker_count) do
      {:ok, pid}
    end
  end

  @impl DynamicSupervisor
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one, max_restarts: 100, max_seconds: 5)
  end

  defp start_workers(supervisor, count) do
    1..count
    |> Enum.each(fn _ -> DynamicSupervisor.start_child(supervisor, @child_spec) end)

    :ok
  end
end
