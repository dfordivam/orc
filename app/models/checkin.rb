class Checkin < ActiveRecord::Base
#  belongs_to :visitor
#  belongs_to :event
#  belongs_to :registration
#  belongs_to :room
  belongs_to :source, :polymorphic => true
#  has_many :buildings
#  has_many :floors
#  has_many :rooms
  belongs_to :building
#  belongs_to :floor
  belongs_to :room
 
#  before_create :set_default_values
#
#  def set_default_values
#    self.is_delete = 0
#    self.is_active = 1
#  end

#  validates :visitor_id, :presence => true
#  validates :event_id, :presence => true
#  validates :registration_id, :presence => true
#  validates :no_of_days, :presence => true, :inclusion => (0..100), :numericality => true
end
