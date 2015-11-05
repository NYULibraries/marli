# This controller handles methods for administrator-managed
# application text, which are displayed to frontend users
#
class ApplicationDetailsController < ApplicationController
  before_filter :authenticate_admin
  respond_to :html, :js

  # GET /application_details
  def index
    @application_details = ApplicationDetail.all
    respond_with(@application_details)
  end

  # GET /application_details/1/edit
  def edit
    @application_detail = ApplicationDetail.find(params[:id])
    respond_with(@application_detail)
  end

  # PUT /application_details/1
  def update
    @application_detail = ApplicationDetail.find(params[:id])
    flash[:notice] = t('application_details.update_success') if @application_detail.update_attributes(application_detail_params)

    respond_with(@application_detail, :location => application_details_url)
  end

  # Toggle status of application open/closed based on existence of a file
  def toggle_application_status
    @application_details = ApplicationDetail.all
    pid_file = "#{Rails.root}/config/app_is_inactive.pid"

    if File.exists? pid_file
      File.delete pid_file
    else
      File.open(pid_file, 'w'){|f| f.write Process.pid}
    end

    respond_with(@application_details, :location => application_details_url) do |format|
      format.js
      format.html { redirect_to application_details_url }
    end
  end

 private

  def application_detail_params
    params.require(:application_detail).permit(:purpose, :the_text, :description)
  end
end
