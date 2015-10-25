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
    users = $group_client.user.full_list(4, nil, 0).result["userlist"]

    users.each do |user|
      customer = Customer.find_by(abbreviation: user["position"])

      Member.create(name: user["name"], phone: user["mobile"], openid: user["userid"], 
        nick_name: user["nick_name"], headimg: user["avatar"], customer: customer)

    end
  end

end
