use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :materia_batch, MateriaBatchWeb.Test.Endpoint,
  http: [port: 4001],
  #server: false,
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: []

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :materia_batch, MateriaBatch.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "materia_batch_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :materia_batch, repo: MateriaBatch.Test.Repo

# Configures GuardianDB
config :guardian, Guardian.DB,
 repo: MateriaBatch.Test.Repo,
 schema_name: "guardian_tokens", # default
#token_types: ["refresh_token"], # store all token types if not set
 sweep_interval: 60 # default: 60 minutes

# Configures MateriaBatch
 config :materia_batch, MateriaBatch.JobSchedules.JobScheduleManager,
  max_concurrent_jobs: 2,
  job_check_interval: 60000 # default 60000msec

# Configures MateriUtils
 config :materia_utils,
  test_base_datetime: "2019-03-03T00:00:00.000Z"