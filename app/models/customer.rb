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
#

class Customer < ActiveRecord::Base
  has_many :machines, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :interface, dependent: :destroy
  has_many :task, dependent: :destroy
  validates :name, presence: true
end
