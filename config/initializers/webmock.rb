if Rails.env.test?
  WebMock.allow_net_connect!
end
