# == Schema Information
# Schema version: 20110526065356
#
# Table name: buildings
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  rooms      :integer
#  floors     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Building < ActiveRecord::Base
  has_many :rooms
end
