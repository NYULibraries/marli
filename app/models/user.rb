class User < ActiveRecord::Base
  include Marli::Affiliations
  devise :omniauthable,:omniauth_providers => [:nyulibraries]

  validate :require_school, on: :update, if: -> { self.validate_fields? }
  validate :require_dob, on: :update, if: -> { self.validate_fields? }

  serialize :address

  attr_accessor :fullname, :validate_fields

  def fullname
    "#{self.firstname} #{self.lastname}"
  end

  def self.search(search)
    if search
      q = "%#{search}%"
      where('firstname LIKE ? || lastname LIKE ? || username LIKE ? || email LIKE ?', q, q, q, q)
    else
      all
    end
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
    elsif dob > 16.years.ago
      errors.add(:base, "Please select a valid date of birth, before #{16.years.ago.year}.")
    end
  end

end
