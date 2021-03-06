module LayoutsHelper
  # Meta tags to include in layout
  def meta
    meta = super
    meta << tag(:meta, :name => "HandheldFriendly", :content => "True")
    meta << tag(:meta, :name => "cleartype", :content => "on")
    meta << favicon_link_tag('https://library.nyu.edu/favicon.ico')
  end

  def application_title
    get_sanitized_detail('title')
  end

  # Print breadcrumb navigation
  def breadcrumbs
    breadcrumbs = super
    breadcrumbs << link_to_unless_current(application_title, root_url)
    breadcrumbs << link_to('Admin', :controller => 'users') if is_in_admin_view?
    breadcrumbs << link_to_unless_current(controller.controller_name.humanize, {:action => :index }) if is_in_admin_view?
    return breadcrumbs
  end

  # Prepend modal dialog elements to the body
  def prepend_body
    content_tag(:div, nil, :class => "modal-container")+
    content_tag(:div, nil, :id => "ajax-modal", :class => "modal hide fade", :tabindex => "-1")
  end

  # Prepend the flash message partial before yield
  def prepend_yield
    content_tag :div, :id => "main-flashses" do
    render :partial => 'common/flash_msg'
    end
  end

  # Boolean for whether or not to show tabs
  # This application doesn't need tabs
  def show_tabs
    false
  end
end
