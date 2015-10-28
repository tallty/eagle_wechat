# == Schema Information
#
# Table name: customers
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  addr         :string(255)
#  explain      :string(255)
#  abbreviation :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  identifier   :string(255)
#

class Customer < ActiveRecord::Base
  has_many :machines, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :interfaces, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :sms_logs, dependent: :destroy
  has_many :api_users, dependent: :destroy
  
  validates :name, presence: true

  after_initialize :task_identifier
  
  private

  def task_identifier
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.identifier ||= chars.sample(8).join
  end 
end
