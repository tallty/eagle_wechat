class InterfacesWorker
  include Sneakers::Worker

  from_queue 'analyze_interface', env: nil

  def work(raw_post)
    InterfacesProcess.push(raw_post)
    ack!  # we need to let queue know that message was received
  end
end
