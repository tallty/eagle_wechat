class MachineProcessor

  # 解析接收到的服务器状态数据,如果数据有异常,报警
  def self.push(raw_post)
    real_hardware_params = MultiJson.load raw_post rescue {}
    return if real_hardware_params.blank?
    Rails.logger.warn "machine identifier: #{real_hardware_params['identifier']}"
    $redis.multi do
      $redis.lpush "#{real_hardware_params['identifier']}_cpu", "#{real_hardware_params['info']['cpu']}"
      $redis.lpush "#{real_hardware_params['identifier']}_memory", "#{real_hardware_params['info']['memory']}"
      $redis.lpush "#{real_hardware_params['identifier']}_net_work", "#{real_hardware_params['info']['net_work']}"
      $redis.lpush "#{real_hardware_params['identifier']}_file_systems", "#{real_hardware_params['info']['file_system']}"
      $redis.hset("machine_last_update_time", "#{real_hardware_params['identifier']}", Time.now.strftime('%Y-%m-%d %H:%M:%S'))
      $redis.ltrim "#{real_hardware_params['identifier']}_cpu", 0, 8640
      $redis.ltrim "#{real_hardware_params['identifier']}_memory", 0, 8640
      $redis.ltrim "#{real_hardware_params['identifier']}_net_work", 0, 8640
      $redis.ltrim "#{real_hardware_params['identifier']}_file_systems", 0, 8640
    end
  end

end
