class AnalyzeTask < BaseService

  def self.publish(exchange, message={})
    Rails.logger.warn "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    Rails.logger.warn "#{exchange}"
    Rails.logger.warn "#{message}"
    x = channel.fanout("message.#{exchange}")
    x.publish(message)
  end

end
