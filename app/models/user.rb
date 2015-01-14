class User < ActiveRecord::Base
  include Marli::Affiliations
  devise :omniauthable,:omniauth_providers => [:nyulibraries]

  validate :require_school, :on => :update, :if => Proc.new {|f| f.submitted_request }
  validate :require_dob, :on => :update, :if => Proc.new {|f| f.submitted_request }

  serialize :address

  attr_accessor :fullname

  def fullname
    "#{self.firstname} #{self.lastname}"
  end

  # acts_as_authentic do |c|
  #   c.validations_scope = :username
  #   c.validate_password_field = false
  #   c.require_password_confirmation = false
  #   c.disable_perishable_token_maintenance = true
  # end

  def self.search(search)
    if search
      q = "%#{search}%"
      where('firstname LIKE ? || lastname LIKE ? || username LIKE ? || email LIKE ?', q, q, q, q)
    else
      all
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
    department "Department"
    school "School"
    affiliation_text "Affiliation"
  end

private

  def require_school
    if school.blank?
      errors.add(:base, "School cannot be blank.")
    end
  end

  def require_dob
    if dob.blank?
      errors.add(:base, "Date of birth cannot be blank.")
    end
  end

end
