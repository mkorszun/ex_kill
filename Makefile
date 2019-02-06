.PHONY:code-analysis deps doc test test_cli

code-analysis: deps
	mix credo

deps: mix.exs
	mix deps.get
	touch deps

doc: deps
	mix docs

test: deps
	MIX_ENV=test mix coveralls

test_ci: deps
	MIX_ENV=test mix coveralls.travis
