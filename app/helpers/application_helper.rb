# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Find out if PID file for deactivating app has been set
  def app_is_active?
    (!File.exists? "#{Rails.root}/config/app_is_inactive.pid")
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
    return "Admin" if user.admin?
    return "Exception" if user.override_access?
  end

  # Find out if use has submitted form already
  def user_submitted(user)
    user.submitted_request
  end

  def renewal_checked?
    (!params[:user].nil? && !params[:user][:user_attributes].nil? && !params[:user][:user_attributes][:marli_renewal].nil? && params[:user][:user_attributes][:marli_renewal] == "Renewal")
  end

  def user_school

  end

  def user_department

  end

end
