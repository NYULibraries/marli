class UserSessionsController < ApplicationController
  include Authpds::Controllers::AuthpdsSessionsController
  
  def logged_out
    redirect_to root_url
  end
end
