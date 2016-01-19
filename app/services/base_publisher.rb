class BasePublisher

  def self.publish(exchange, message={})
    x = channel.fanout("message.#{exchange}")
    x.publish(message)
  end

  private
  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    @connection ||= Bunny.new.tap do |c|
      c.start
    end
  end
end
