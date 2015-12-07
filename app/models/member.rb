# == Schema Information
#
# Table name: members
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  phone       :string(255)
#  email       :string(255)
#  openid      :string(255)
#  nick_name   :string(255)
#  headimg     :string(255)
#  customer_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Member < ActiveRecord::Base
  belongs_to :customer

  def self.add_member_by_department_id department_id
    users = $group_client.user.full_list(department_id, nil, 0).result["userlist"]

    users.each do |user|
      customer = Customer.where(abbreviation: user["position"]).first
      member = Member.find_or_create_by phone: user['mobile']
      member.name      = user['name']
      member.openid    = user['userid']
      # member.nick_name = user['nick_name']
      member.headimg   = user['avatar']
      member.customer  = customer
      member.save

    end
  end

end
