class Customer < ActiveRecord::Base
  has_many :machines, dependent: :destroy
  has_many :members, dependent: :destroy
  validates :name, presence: true
end
