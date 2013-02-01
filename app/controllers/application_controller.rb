# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time

  # Use nyu assets layout
  layout "bobcat"
  
  protect_from_forgery

  #Authpds user functions
  include Authpds::Controllers::AuthpdsController
  
  # Retrieve the web text for this borrower affiliation based on the status
  def affiliation
    @affiliation ||= auth_types_collection[current_user.user_attributes[:bor_status]]
  end
  helper_method :affiliation
  
  # Filter users to root if not admin
  def authenticate_admin
    if !is_admin?
      redirect_to :root, :status => 401
      return false
    else
      return true
    end
  end
  protected :authenticate_admin
  
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
   @current_user ||= User.find_by_username("nonadmin")
  end
  alias :current_user :current_user_dev if Rails.env == "development"
  
  # Create a hash of :code => :web_text pairs for auth_types
  def auth_types_collection
    auth_types_h = Hash.new
    auth_types.collect {|patron_status| {patron_status["code"] => patron_status["web_text"]}}.each {|patron_status| auth_types_h.merge!(patron_status)}
    return auth_types_h
  end
  
  # Collect a simple array of codes from auth_types
  def auth_types_array
    auth_types.collect {|x| x["code"] }
  end
  
  # Fetch auth_types from privileges guide
  # * Get patron statuses with access to the MaRLi sublibrary
  def auth_types 
    @auth_types = Rails.cache.fetch "auth_types", :expires_in => 5.minutes do
      HTTParty.get("#{Settings.privileges.base_url}/patrons.json?sublibrary_code=#{Settings.privileges.marli_code}")
    end
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
  
  # Authorize patron access to this application
  # * Has access if authorized, exception or admin
  # * If logged in but not authorized, rendered an error page
  # * Otherwise redirect to login page, no anonymous access allowed
  def authorize_patron
    if is_authorized? or is_exception? #or is_authorized? is_admin?
      return true
    elsif !current_user.nil?
      render 'user_sessions/unauthorized_patron'
    else
      redirect_to :login, :status => 401
      return false
    end
  end

  # Set robots.txt per environment
  def robots
    robots = File.read(Rails.root + "public/robots.#{Rails.env}.txt")
    render :text => robots, :layout => false, :content_type => "text/plain"
  end

end