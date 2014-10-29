class User < ActiveRecord::Base
  include Marli::Affiliations

  # attr_accessible :dob, :submitted_request, :submitted_at, :barcode
  # Attributes used by authpds
  # attr_accessible :crypted_password, :current_login_at, :current_login_ip, :email, :firstname, :last_login_at, :last_login_ip, :last_request_at, :lastname, :login_count, :mobile_phone, :password_salt, :persistence_token, :refreshed_at, :session_id, :user_attributes, :username

  validate :require_school, :on => :update, :if => Proc.new {|f| f.submitted_request }
  validate :require_dob, :on => :update, :if => Proc.new {|f| f.submitted_request }

  serialize :user_attributes  
  
  attr_accessor :fullname
  
  def fullname
    "#{self.firstname} #{self.lastname}"
  end
  
  acts_as_authentic do |c|
    c.validations_scope = :username
    c.validate_password_field = false
    c.require_password_confirmation = false  
    c.disable_perishable_token_maintenance = true
  end

  def self.search(search)
    if search
      q = "%#{search}%"
      where('firstname LIKE ? || lastname LIKE ? || username LIKE ? || email LIKE ?', q, q, q, q)
    else
      scoped
    end
  end
  
  # Create a CSV format
  comma do
    username
    firstname
    lastname
    email
    submitted_at {|submitted_at| submitted_at.strftime("%m/%d/%Y") unless submitted_at.nil? }
    dob "Date of birth"
    barcode "NYPL Barcode"
    user_attributes "Department" do |user_attributes| user_attributes[:department] end
    user_attributes "School" do |user_attributes| user_attributes[:school] end
    affiliation_text "Affiliation"
  end
  
private
  
  def require_school
    if user_attributes[:school].blank?
      errors.add(:base, "School cannot be blank.")
    end
  end
  
  def require_dob
    if dob.blank?
      errors.add(:base, "Date of birth cannot be blank.")
    end
  end
  
end
