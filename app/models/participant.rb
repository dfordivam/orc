class Participant 
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :event_id, :gender, :visitor_type, :registration_id
  
#  validates_presence_of :name
#  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
#  validates_length_of :content, :maximum => 500
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
 
  def self.from_registration(registration )
    new(:name => registration.visitor.name, :event_id => registration.event_id, :visitor_type => registration.visitor.visitor_type, :gender => registration.visitor.gender , :registration_id => registration.id) 

  end

  def self.from_accompany_visitor(av )
    new(:name => av.name, :event_id => av.event_id, :visitor_type => av.visitor_type, :gender => av.gender , :registration_id => av.registration_id) 
  end

  def persisted?
    false
  end
end

