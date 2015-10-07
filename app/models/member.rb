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
end
