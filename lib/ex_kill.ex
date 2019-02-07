defmodule ExKill do
  @moduledoc "ExKill library"

  @doc """
  Starts supervisor terminator with default config
  """
  def start_link() do
    ExKill.SupervisorTerminator.start_link()
  end

  @doc """
  Starts supervisor terminator with custom config
  """
  def start_link(config) do
    ExKill.SupervisorTerminator.start_link(config)
  end

  @doc """
  Adds dynamically new supervisor for chaos kill
  """
  def register_supervisors(supervisors) do
    ExKill.SupervisorTerminator.register(supervisors)
  end
end
