# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'json'
class ApplicationController < ActionController::Base
  layout Proc.new{ |controller| (controller.request.xhr?) ? false : "application" }
  rescue_from Faraday::ConnectionFailed, :with => :connection_error

  include Marli::Affiliations
  helper_method :affiliation_text, :affiliation, :auth_types
  helper_method :detail_by_purpose, :get_sanitized_detail, :text_exists

  protect_from_forgery

  def connection_error
    render 'errors/unexpected_error', :layout => false, :status => 500 and return
  end
  protected :connection_error

  # Filter users to root if not admin
  def authenticate_admin
    if current_user.nil? || !current_user.admin?
      redirect_to root_url and return unless performed?
    else
      return true
    end
  end
  protected :authenticate_admin

  prepend_before_filter :passive_login
  def passive_login
    if !cookies[:_check_passive_login]
      cookies[:_check_passive_login] = true
      redirect_to passive_login_url
    end
  end

  def current_user_dev
    @current_user ||= User.new(admin: true, username: 'tst123', firstname: "Cleo")
  end
  alias_method :current_user, :current_user_dev if Rails.env.development?

  # This makes sure you redirect to the correct location after passively
  # logging in or after getting sent back not logged in
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  # After signing out from the local application,
  # redirect to the logout path for the Login app
  def after_sign_out_path_for(resource_or_scope)
    if logout_path.present?
      logout_path
    else
      super(resource_or_scope)
    end
  end

  # Authorize patron access to this application
  # * Has access if authorized, exception or admin
  # * If logged in but not authorized, rendered an error page
  # * Otherwise redirect to login page, no anonymous access allowed
  def authorize_patron
    unless current_user.nil?
      if current_user.admin? or current_user.override_access? or current_user.authorized?
        return true
      else !current_user.nil?
        render 'errors/unauthorized_patron'
      end
    else
      redirect_to login_url(origin: request.url) unless performed?
    end
  end

  # For dev purposes
  def current_user_dev
   @current_user ||= User.find_by_username("admin")
  end
  # alias :current_user :current_user_dev if Rails.env == "development"

  # Alias new_session_path as login_path for default devise config
  def new_session_path(scope)
    login_path
  end

  # Protect against SQL injection by forcing column to be an actual column name in the model
  def sort_column klass, default_column = "title_sort"
    klass.constantize.column_names.include?(params[:sort]) ? params[:sort] : default_column
  end
  protected :sort_column

  # Protect against SQL injection by forcing direction to be valid
  def sort_direction default_direction = "asc"
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default_direction
  end
  helper_method :sort_direction
  protected :sort_direction

  # Return boolean matching the url to find out if we are in the admin view
  def is_in_admin_view
    !request.path.match("/admin").nil?
  end
  alias :is_in_admin_view? :is_in_admin_view
  helper_method :is_in_admin_view?

  # Set robots.txt per environment
  def robots
    robots = File.read(Rails.root + "public/robots.#{Rails.env}.txt")
    render :text =>@robots, :layout => false, :content_type => "text/plain"
  end

  private

  def logout_path
    if ENV['LOGIN_URL'].present? && ENV['SSO_LOGOUT_PATH'].present?
      "#{ENV['LOGIN_URL']}#{ENV['SSO_LOGOUT_PATH']}"
    end
  end

  def passive_login_url
    "#{ENV['LOGIN_URL']}#{ENV['PASSIVE_LOGIN_PATH']}?client_id=#{ENV['APP_ID']}&return_uri=#{request_url_escaped}&login_path=#{login_path_escaped}"
  end

  def request_url_escaped
    CGI::escape(request.url)
  end

  def login_path_escaped
    CGI::escape("#{Rails.application.config.action_controller.relative_url_root}/login")
  end

end
