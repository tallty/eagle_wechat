class AnalyzeTasksWorker
  include Sneakers::Worker

  from_queue 'analyze_task', env: nil

  def work(raw_post)
    TaskProcess.push(raw_post)
    ack!  # we need to let queue know that message was received
  end
end
