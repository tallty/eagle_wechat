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
  
  has_many :interfaces_api_users
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

  def self.save_interface_api_users(interface_id, api_users)
    create_api_users = api_users.to_a
    InterfacesApiUser.transaction do
      unless create_api_users.empty?
        create_api_users.each do |api_user_id|
          InterfacesApiUser.create(interface_id: interface_id.to_i, api_user_id: api_user_id)
        end
      end
    end
  end
end
