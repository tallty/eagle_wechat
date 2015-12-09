class RecentTasks

  def self.push(raw_post)
    Rails.logger.warn raw_post
    # $group_client.message.send_text("alex6756", "", "", 1, raw_post)
  end
end
