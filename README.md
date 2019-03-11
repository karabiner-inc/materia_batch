# Materia Batch

[![hex.pm](https://img.shields.io/hexpm/l/plug.svg)](https://github.com/karabiner-inc/materia_batch/blob/master/LICENSE)
[![Coverage Status](https://coveralls.io/repos/github/karabiner-inc/materia_batch/badge.svg?branch=master)](https://coveralls.io/github/karabiner-inc/materia_batch?branch=master)
[![Build Status](https://travis-ci.org/karabiner-inc/materia_batch.svg?branch=master)](https://travis-ci.org/karabiner-inc/materia_batch)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


## Installation

add deps

mix.exs

```
 defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:mariaex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:materia_batch, "~> 0.1.0"}, #<- add here
    ]
  end
```

## Configure

 this repository based on materia(https://github.com/karabiner-inc/materia)
 you need configure materia before setting materia_batch configure.


 #### generate migration files

  create migration files.

  ```
  mix materia_batch.gen.migration
  mix ecto.migration
  ```
#### configure for BatchManager

add configure your config.exs or environment config file. 

```
# Configures MateriaBatch
 config :materia_batch, MateriaBatch.JobSchedules.JobScheduleManager,
  max_concurrent_jobs: 2, # number of max concurrent execute job
  job_check_interval: 60000 # default 60000msec

```

#### add BatchManager GenServer Process

add MateriaBatch.BatchManagers.JobScheduleManager in you application children process.

```
defmodule MateriaBatch.Test.Application do
  use Application

  ~~~

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(MateriaBatch.Test.Repo, []),
      # Start the endpoint when the application starts
      supervisor(MateriaBatchWeb.Test.Endpoint, []),
      # Start your own worker by calling: MateriaBatch.Worker.start_link(arg1, arg2, arg3)
      # worker(MateriaBatch.Worker, [arg1, arg2, arg3]),
      worker(MateriaBatch.BatchManagers.JobScheduleManager, []) # add here
    ]

   ~~~
  
end
```

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix