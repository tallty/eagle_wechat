json.machines(@machines) do |machine|
  json.name machine['name']
  json.cpu_percent machine.cpu_percent
  json.memory_percent machine.memory_percent
  json.disk_percent eval(MachineInfo.get_info("file_systems", machine.identifier))["percent_used"][-2].to_i.to_s + "%"
end