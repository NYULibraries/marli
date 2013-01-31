# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Find out if PID file for deactivating app has been set
  def app_is_active?
    (!File.exists? "#{Rails.root}/config/app_is_inactive.pid")
  end
  
  # Get the affiliation title if it exists or the default text otherwise
  def affiliation_text
    return affiliation unless affiliation.nil?
    get_sanitized_detail("default_patron_type")
  end

  # Format and santitize detail from database
  def get_formatted_detail(purpose, css = nil)
   simple_format(get_sanitized_detail(purpose), :class => css)
  end
  
  # Fetch application detail text by purpose
  def detail_by_purpose(purpose)
    ApplicationDetail.find_by_purpose(purpose)
  end

  # Sanitize detail
  def get_sanitized_detail(purpose)
   application_detail = detail_by_purpose(purpose)
   return print_sanitized_html(application_detail.the_text) if text_exists?(purpose)
  end

  # Returns boolean for whether or not there exists application detail text for this purpose
  def text_exists?(purpose)
   text = detail_by_purpose(purpose)
   return !(text.nil? || text.the_text.empty?)
  end

  # Sanitize HTML
  def print_sanitized_html(html)
   sanitize(html, :tags => %w(b strong i em br p a ul li), :attributes => %w(target href class)).html_safe
  end

  # Retrieve a value matching a key to an icon class name
  def icons key
    icons_info[key.to_s]
  end
  
  # Load the icons YAML info file
  def icons_info
    @icons_info ||= YAML.load_file( File.join(Rails.root, "config", "icons.yml") )
  end
  
  # Generate an icon tag with class key
  def icon_tag key
    content_tag :i, "", :class => icons(key)
  end
  
  # Generate an abbr tag for long words
  def word_break word
    if word.length > 10
      content_tag :abbr, truncate(word, :length => 10), :title => word
    else
      word
    end
  end
  
  # Generate link to sorting action
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    direction_icon = (direction.eql? "desc") ? :sort_desc : :sort_asc
    search = params[:search]  
    html = link_to title, params.merge(:sort => column, :direction => direction, :page => nil, :id => ""), {:class => css_class}
    html << icon_tag(direction_icon) if column == sort_column
    return html
  end
  
  # Get the status of this user
  def user_status(user)
    return "Admin" if user.user_attributes[:marli_admin]
    return "Exception" if user.user_attributes[:marli_exception]
  end
  
  # Find out if use has submitted form already
  def user_submitted(user)
    user.submitted_request
  end
  
end
