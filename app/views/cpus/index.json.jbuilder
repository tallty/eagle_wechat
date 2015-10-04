json.array!(@cpus) do |cpu|
  json.extract! cpu, :id
  json.url cpu_url(cpu, format: :json)
end
