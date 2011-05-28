# == Schema Information
# Schema version: 20110526065356
#
# Table name: visitors
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  age            :integer
#  address        :string(255)
#  gender         :boolean
#  mobile_no      :integer
#  visitor_type   :string(255)
#  designation    :string(255)
#  organisation   :string(255)
#  transport_mode :string(255)
#  checkin_time   :time
#  checkin_date   :date
#  created_at     :datetime
#  updated_at     :datetime
#

class Visitor < ActiveRecord::Base
  has_many :checkins
#  attr_accessible :name, :age

  validates :name, :presence => true
end
