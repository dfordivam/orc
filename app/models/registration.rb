class Registration < ActiveRecord::Base

  belongs_to :visitor

  belongs_to :event

  has_many :checkins

  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
  end

  validates :event_id, :presence => true
  validates :visitor_id, :presence => true

end
