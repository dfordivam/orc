class Registration < ActiveRecord::Base

  belongs_to :visitor

  belongs_to :event

  has_many :checkins

  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
    self.is_guide = 0
    self.is_driver_along = 0
    self.is_driver_accom_req = 0
    self.is_driver_in_gyan = 0
    self.is_special_care_req = 0
    self.is_physically_challenged = 0
  end

  validates :visitor_id, :presence => true

end
