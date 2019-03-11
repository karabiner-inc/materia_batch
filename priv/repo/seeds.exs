# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Materia.Repo.insert!(%Materia.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MateriaUtils.Test.TsvParser

alias MateriaBatch.JobMasters

job_masters = "
job_code	name	module	function	params	schedule_time	error_action	reschedule_period_sec	priority	schedule_period_type	calender_type
JobSceduleDailySweep	ジョブスケジュール日次削除	MateriaBatch.BatchJobs.TableSweeper	run	\"MateriaBatch.JobSchedules.JobSchedule\",\"end_datetime\", 2, {\"and\": [{\"status\": \"S\"}],\"or\": [] }	09:00	abort	60	100	Daily	365Days
SleepDammy1	スリープダミー１	Process	sleep	500	09:00	abort	60	100	Daily	365Days
NotDaily	日次バッチ以外	Materia.Accounts	list_users_by_params	[{\"and\": {\"role\": \"admin\"}], \"or\": [{\"status\":1}, {\"status\": 2}] }	09:00	abort	60	100	Monthly	365Days
"


jsons = TsvParser.parse_tsv_to_json(job_masters, "name")

    results = jsons
    |> Enum.map(fn(json) ->
      {:ok, result} = json
      |> JobMasters.create_job_master()
    end)






alias MateriaBatch.JobSchedules

job_schedules = "
job_code	name	module	function	params	schedule_datetime	next_check_datetime	error_action	reschedule_period_sec	priority	status	start_datetime	end_datetime
TEST001	実行対象ジョブ	Process	sleep	5000	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	I	[NULL]	[NULL]
TEST002	 未来ジョブ	Process	sleep	5000	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	I	[NULL]	[NULL]
TEST003	完了済みジョブ	Process	sleep	5000	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	S	2019-03-01 09:00:00	2019-03-01 00:00:00
TEST004	エラージョブ	Hogehoge	sleep	5000	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	E	[NULL]	[NULL]
TEST005	停止ジョブ	Process	sleep	5000	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	P	[NULL]	[NULL]
TEST006	実行中ジョブ	Process	sleep	5000	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	R	[NULL]	[NULL]
TEST007	実行対象ジョブ2	Process	sleep	5000	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	I	[NULL]	[NULL]
TEST008	完了済みジョブ2	Process	sleep	5000	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	S	2019-03-01 09:00:00	2019-03-01 00:00:01
TEST009	エラージョブ2	Poison	decode	\"aaa\"	2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	E	[NULL]	[NULL]
TEST010	エラージョブ3	MateriaBatch.JobSchedules	list_job_schedules		2019-03-01 09:00:00	2019-03-01 09:00:00	abort	60	100	R	[NULL]	[NULL]
"


jsons = TsvParser.parse_tsv_to_json(job_schedules, "name")

    results = jsons
    |> Enum.map(fn(json) ->
      {:ok, result} = json
      |> JobSchedules.create_job_schedule()
    end)





