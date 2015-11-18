# == Schema Information
#
# Table name: api_users
#
#  id          :integer          not null, primary key
#  appid       :string(255)
#  company     :string(255)
#  customer_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ApiUser < ActiveRecord::Base
  belongs_to :customer
  has_many :total_interfaces
  
  has_many :interfaces_api_users, dependent: :destroy
  has_many :interfaces, through: :interfaces_api_users

  def fetch(url=nil)
    conn = Faraday.new(:url => "http://61.152.122.112:8080") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
    response = conn.get do |req|
      req.url "/api_users"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end
    content = MultiJson.load response.body
    customer = Customer.first
    $redis.del("api_users_cache")
    content.each do |item|
      user = ApiUser.find_or_create_by customer: customer, appid: item[0]
      user.company = item[-1]
      user.save

      $redis.hset("api_users_cache", "#{customer.identifier}_#{user.appid}", "#{user.company}")
    end
  end
end
