class BaseService

  def self.channel
    @channel ||= connection.create_channel
  end
  
  def self.connection
    @connection ||= Bunny.new.tap do |c|
      c.start
    end
  end
end
