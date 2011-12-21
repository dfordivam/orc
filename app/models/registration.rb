class Registration < ActiveRecord::Base

  belongs_to :visitor

  belongs_to :event

  has_many :checkins

end
