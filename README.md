# ExKill

Register your supervised processes for chaos kill.

## Usage

~~~bash
iex> TestSupervisor.start(:one)
iex> %ExKill.Config{frequency: 2000, probability: 10, processes: [:one]} |> ExKill.start_link()
~~~