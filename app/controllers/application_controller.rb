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
    render 'user_sessions/unexpected_error', :layout => false, :status => 500 and return
  end
  protected :connection_error

  # Filter users to root if not admin
  def authenticate_admin
    if !is_admin?
      redirect_to root_url and return unless performed?
    else
      return true
    end
  end
  protected :authenticate_admin

  # Authorize patron access to this application
  # * Has access if authorized, exception or admin
  # * If logged in but not authorized, rendered an error page
  # * Otherwise redirect to login page, no anonymous access allowed
  def authorize_patron
    if is_admin? or is_exception? or is_authorized?
      return true
    elsif !current_user.nil?
      render 'user_sessions/unauthorized_patron'
    else
      redirect_to login_url unless performed?
    end
  end

  # Return true if user is marked as admin
  def is_admin
    (!current_user.nil? and current_user.admin?)
  end
  alias :is_admin? :is_admin
  helper_method :is_admin?

  # Return true if user is marked as an exception
  # * An 'exception' is a user who doesn't have admin privileges and isn't
  #   an authorized patron status but still is granted access to this app
  def is_exception
    (!current_user.nil? and current_user.override_access?)
  end
  alias :is_exception? :is_exception

  # Return true if user is an authorized patron status
  def is_authorized
    (!current_user.nil? and auth_types_array.include? current_user.patron_status)
  end
  alias :is_authorized? :is_authorized

  # For dev purposes
  def current_user_dev
   @current_user ||= User.find_by_username("admin")
  end
  alias :current_user :current_user_dev if Rails.env == "development"

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

end
