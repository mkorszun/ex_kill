defmodule ExKill do
  def start_link() do
    ExKill.SupervisorTerminator.start_link()
  end

  def start_link(config) do
    ExKill.SupervisorTerminator.start_link(config)
  end

  def register_supervisors(supervisors) do
    ExKill.SupervisorTerminator.register(supervisors)
  end
end
