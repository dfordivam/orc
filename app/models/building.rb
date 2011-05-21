# == Schema Information
# Schema version: 20110521152423
#
# Table name: buildings
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  rooms      :integer(4)
#  floors     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Building < ActiveRecord::Base
  has_many :rooms
end
