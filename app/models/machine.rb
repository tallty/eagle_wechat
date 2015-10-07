# == Schema Information
#
# Table name: machines
#
#  id               :integer          not null, primary key
#  identifier       :string(255)
#  name             :string(255)
#  explain          :string(255)
#  operating_status :integer          default(0)
#  customer_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Machine < ActiveRecord::Base
  belongs_to :customer
  has_one :machine_detail
  enum operating_status: { stoped: 0, running: 1 }

  after_initialize :generate_identifier

  private

  def generate_identifier
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.identifier ||= chars.sample(16).join
  end  

end
