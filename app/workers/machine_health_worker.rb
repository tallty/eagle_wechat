class MachineHealthWorker
  include Sneakers::Worker

  from_queue 'machine_health', env: nil

  def work(raw_post)
    MachineProcessor.push(raw_post)
    ack!  # we need to let queue know that message was received
  end
end
