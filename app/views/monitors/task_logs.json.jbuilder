json.task_logs(@task_logs) do |name, logs|
  json.name name
  json.logs(logs) do |log|
    json.time log[0]
    json.period log[1]
    json.spent log[2]
  end
end