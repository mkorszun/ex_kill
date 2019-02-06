[![Build Status](https://travis-ci.org/mkorszun/ex_kill.svg?branch=master)](https://travis-ci.org/mkorszun/ex_kill)
[![Coverage Status](https://coveralls.io/repos/github/mkorszun/ex_kill/badge.svg?branch=master)](https://coveralls.io/github/mkorszun/ex_kill?branch=master)
# ExKill

Register your supervised processes for chaos kill.

Main features:
* ability to register whole supervision trees for chaos kill at once
* ability to register supervisors by names, where resolution happens on kill time

## Usage

~~~bash
iex> TestSupervisor.start(:one)
iex> %ExKill.Config{frequency: 2000, probability: 10, processes: [:one]} |> ExKill.start_link()
~~~