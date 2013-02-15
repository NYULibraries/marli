# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'json'
class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time

  # Use nyu assets layout
  layout "bobcat"
  
  protect_from_forgery

  #Authpds user functions
  include Authpds::Controllers::AuthpdsController
  
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
  	(!current_user.nil? and current_user.user_attributes[:marli_admin])
  end
  alias :is_admin? :is_admin
  helper_method :is_admin?  
  
  # Return true if user is marked as an exception
  # * An 'exception' is a user who doesn't have admin privileges and isn't 
  #   an authorized patron status but still is granted access to this app
  def is_exception
    (!current_user.nil? and current_user.user_attributes[:marli_exception])
  end
  alias :is_exception? :is_exception
  
  # Return true if user is an authorized patron status
  def is_authorized
    (!current_user.nil? and auth_types_array.include? current_user.user_attributes[:bor_status])
  end
  alias :is_authorized? :is_authorized

  # For dev purposes
  def current_user_dev
   @current_user ||= User.find_by_username("ba36")
  end
  alias :current_user :current_user_dev if Rails.env == "development"
  
  # Create a hash of :code => :web_text pairs for auth_types
  def auth_types_collection
    @auth_types_h ||= Rails.cache.fetch "auth_types_h", :expires_in => 24.hours do
      # Uses the Hash object to cast a mapped array as a hash
      Hash[auth_types.map {|x| [x["code"], x["web_text"]]}]
    end
  end
  
  # Collect a simple array of codes from auth_types
  def auth_types_array
    @auth_types_array ||= Rails.cache.fetch "auth_types_array", :expires_in => 24.hours do
      auth_types.collect {|x| x["code"] } 
    end
  end
  
  # Fetch auth_types from privileges guide
  # * Get patron statuses with access to the MaRLi sublibrary
  def auth_types 
    @auth_types ||= HTTParty.get("#{Settings.privileges.base_url}/patrons.json?sublibrary_code=#{Settings.privileges.marli_code}")
  rescue Timeout::Error => e
    @error = e
    render 'user_sessions/timeout_error'
  end
  helper_method :auth_types
  
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
    render :text => robots, :layout => false, :content_type => "text/plain"
  end
  
  # Retrieve the web text for this borrower affiliation based on the status
  def affiliation
    @affiliation ||= auth_types_collection[current_user.user_attributes[:bor_status]] unless current_user.user_attributes[:bor_status].nil?
  end
  helper_method :affiliation
    
  # Get the affiliation title if it exists or the default text otherwise
  def affiliation_text
    return affiliation unless affiliation.nil?
    get_sanitized_detail("default_patron_type")
  end
  helper_method :affiliation_text
  
  # Fetch application detail text by purpose
  def detail_by_purpose(purpose)
    ApplicationDetail.find_by_purpose(purpose)
  end
  helper_method :detail_by_purpose

  # Sanitize detail
  def get_sanitized_detail(purpose)
   application_detail = detail_by_purpose(purpose)
   return application_detail.the_text.html_safe if text_exists?(purpose)
  end
  helper_method :get_sanitized_detail

  # Returns boolean for whether or not there exists application detail text for this purpose
  def text_exists?(purpose)
   text = detail_by_purpose(purpose)
   return !(text.nil? || text.the_text.empty?)
  end
  helper_method :text_exists

end