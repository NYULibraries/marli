# This controller handles methods for administrator-managed
# application text, which are displayed to frontend users
#
class ApplicationDetailsController < ApplicationController
  before_filter :authenticate_admin
  
  # GET /application_details
  def index
    @application_details = ApplicationDetail.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /application_details/1/edit
  def edit
    @application_detail = ApplicationDetail.find(params[:id])
  end

  # PUT /application_details/1
  def update
    @application_detail = ApplicationDetail.find(params[:id])

    respond_to do |format|
      if @application_detail.update_attributes(params[:application_detail])
        flash[:notice] = t('application_details.update_success')
        format.html { redirect_to(application_details_path) }
      else
        format.html { render :edit }
      end
    end
  end
  
  # Toggle status of application open/closed based on existence of a file
  def toggle_application_status
    pid_file = "#{Rails.root}/config/app_is_inactive.pid"
    
    if File.exists? pid_file
      File.delete pid_file
    else
      File.open(pid_file, 'w'){|f| f.write Process.pid} 
    end
    
    respond_to do |format|
      format.html { redirect_to application_details_url } unless request.xhr?
      format.js { render :layout => false } if request.xhr?
    end
  end

end
