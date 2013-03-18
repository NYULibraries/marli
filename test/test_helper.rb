unless ENV['CI']
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start
end

require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic'
require 'authlogic/test_case'

class User
  def nyuidn
    user_attributes[:nyuidn]
  end
  
  def error; end
  
  def uid
    username
  end
end

class ActiveSupport::TestCase
  fixtures :all
  
  def set_dummy_pds_user(user_session)
    user_session.instance_variable_set("@pds_user".to_sym, users(:real_user))
  end

end
