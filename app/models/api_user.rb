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

  def as_json(options=nil)
    {
      id: id,
      appid: appid,
      company: company
    }
  end

  def simplify_sort customer, datetime
    all_result = get_api_user_sort customer, datetime
    length = 3
    result = Array.new(all_result[0..length-1])
    if all_result.size > length
      other_count = all_result[length - 1..-1].inject(0) {|sum,value| sum + value[:count]}
      result << {:company => '其它', :count => other_count}
    end
    result
  end

  def get_api_user_sort customer, datetime
    api_users = customer.api_users.where("company <> ?", "测试接口[大唐]").as_json
    count = TotalInterface.user_analyz_daily(customer, datetime)
    api_users.each do |user|
      user[:count] = count[user[:id]] || 0
    end
    api_users.sort! { |x, y| y[:count] <=> x[:count] }

  end

  def write_a_u_id_to_cache
    users = ApiUser.all
    users.each do |user|
      $redis.hset "api_user_info_cache", user.appid, user.id
    end
  end

  def self.get_api_user_id appid
    return if appid.blank?
    $redis.hget "api_user_info_cache", appid
  end

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
