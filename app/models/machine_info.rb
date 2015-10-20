class MachineInfo

  # info: cpu, memory, net_work
  def self.get_list(info, machine_id)
    list = $redis.lrange("#{machine_id}_#{info}", 0, 100)
  end

  def self.get_info(info, machine_id)
    info = $redis.lpop("#{machine_id}_#{info}")
  end
end
