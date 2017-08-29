class User < ActiveRecord::Base
  include Marli::Affiliations
  devise :omniauthable,:omniauth_providers => [:nyulibraries]

  validate :require_school, on: :update, if: -> { self.validate_fields? }
  validates_presence_of :username, :email

  serialize :address

  acts_as_indexed fields: [:fullname, :username, :email]

  attr_accessor :fullname, :validate_fields

  def fullname
    "#{self.firstname} #{self.lastname}"
  end

  def authorized?
    auth_types_array.include?(self.patron_status)
  end

  def validate_fields?
    (self.validate_fields) ? true : false
  end

  # Create a CSV format
  comma do
    username
    firstname
    lastname
    email
    submitted_at {|submitted_at| submitted_at.strftime("%m/%d/%Y") unless submitted_at.nil? }
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


end
