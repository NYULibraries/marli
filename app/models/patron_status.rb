class PatronStatus < ActiveRecord::Base
  attr_accessible :code, :web_text
  validates_presence_of :code, :web_text
  validates_uniqueness_of :code
end
