# == Schema Information
# Schema version: 20110526065356
#
# Table name: roles
#
#  id         :integer         not null, primary key
#  rolename   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  has_many :users
end
