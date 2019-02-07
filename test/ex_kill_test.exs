defmodule ExKillTest do
  use ExUnit.Case
  doctest ExKill

  test "will terminate supervision tree" do
    {:ok, pid} = TestSupervisor.start(:sup, 10, max_restarts: 2, max_seconds: 5)
    Process.monitor(pid)

    %ExKill.Config{frequency: 10, probability: 100, processes: [:sup]} |> ExKill.start_link()

    assert_receive {:DOWN, _, _, ^pid, :shutdown}
    refute Process.alive?(pid)
  end

  test "will keep supervision tree unaffected when probability is 0" do
    {:ok, pid} = TestSupervisor.start(:sup, 10, max_restarts: 2, max_seconds: 5)
    Process.monitor(pid)

    %ExKill.Config{frequency: 10, probability: 0, processes: [:sup]} |> ExKill.start_link()

    assert Process.alive?(pid)
  end
end
