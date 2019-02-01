defmodule TestWorker do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, [])

  @impl GenServer
  def init(_) do
    {:ok, []}
  end
end
