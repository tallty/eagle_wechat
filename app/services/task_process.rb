class TaskProcess
  
  def self.push(raw_post)
    $redis.hset "task_process_temp", "123", "raw_post"
  end
end
