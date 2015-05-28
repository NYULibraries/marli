require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic'
require 'authlogic/test_case'
require 'pry'

class User < ActiveRecord::Base
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

# VCR is used to 'record' HTTP interactions with
# third party services used in tests, and play em
# back. Useful for efficiency, also useful for
# testing code against API's that not everyone
# has access to -- the responses can be cached
# and re-used.
require 'vcr'
require 'webmock'

# To allow us to do real HTTP requests in a VCR.turned_off, we
# have to tell webmock to let us.
WebMock.allow_net_connect!

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.default_cassette_options = { allow_playback_repeats: true, record: :new_episodes }
  # webmock needed for HTTPClient testing
  c.hook_into :webmock
  c.filter_sensitive_data("https://localhost") { ENV['PRIVILEGES_BASE_URL'] }
  c.filter_sensitive_data("marli") { ENV['PRIVILEGES_SUBLIBRARY_CODE'] }
end
