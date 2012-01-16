class Visitor < ActiveRecord::Base

  has_many :checkins
  has_many :registrations
  

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

#  attr_accessible :name, :age

  validates :name, :presence => true
  #validates :dob, :presence => true
  validates :age, :presence => true, :numericality => true, :inclusion => (0..100)
  validates :address, :presence => true
  validates :gender, :presence => true
  #validates :mobile_no, :presence => true, :length => 10..10, :numericality => true
  validates :mobile_no, :length => 10..10, :numericality => true, :if => Proc.new { |visitor| visitor.mobile_no != ''}
  validates :visitor_type, :presence => true
  validates :in_gyan_years, :presence => true, :if => Proc.new { |visitor| visitor.visitor_type == 'bk'}, :inclusion => (0..90), :numericality => true
  validates :centre_addr, :presence => true, :if => Proc.new { |visitor| visitor.visitor_type == 'bk'}
  validates :is_physically_challenged, :presence => true

# The following code (define_index) is needed by thinking-sphinx gem to index this class
  define_index do 
    indexes "LOWER(name)", :as => :name, :sortable => true
    indexes :address
    indexes :centre_addr
    set_property :enable_star => 1
    set_property :min_prefix_len => 2
  end
end
