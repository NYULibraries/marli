require 'vcr'

VCR.configure do |c|
  # Capybara with poltergeist js driver uses this /__identify__ path
  # which we want to always ignore in VCR
  # Selenium uses the /hub/session path
  # See: https://github.com/vcr/vcr/issues/229
  c.ignore_request do |request|
    URI(request.uri).path == "/__identify__" || URI(request.uri).path =~ /\/hub\/session/
  end
  c.ignore_request do |request|
    URI(request.uri).path == "/oauth/token"
  end
  c.ignore_localhost = true
  c.default_cassette_options = { allow_playback_repeats: true }
  # c.debug_logger = $stdout
  c.hook_into :webmock
  # c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'features/cassettes'
  c.filter_sensitive_data("https://localhost") { ENV['PRIVILEGES_BASE_URL'] }
  c.filter_sensitive_data("marli") { ENV['PRIVILEGES_SUBLIBRARY_CODE'] }
  c.filter_sensitive_data("BOR_ID") { ENV['BOR_ID'] }
  c.filter_sensitive_data("http://aleph.library.edu") { ENV['ALEPH_HOST'] }
  c.filter_sensitive_data("Eloper, Dev") { ENV['BOR_NAME'] }
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true, record: :new_episodes, match_requests_on: [:path]
end
