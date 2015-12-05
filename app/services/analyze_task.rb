class AnalyzeTask < BaseService

  def self.publish(exchange, message={})
    x = channel.fanout("message.#{exchange}")
    x.publish(message)
  end

end
