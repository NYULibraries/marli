class RegistrationController < ApplicationController
  before_filter :authorize_patron
  
  # Default action
  def index_register
    @user = current_user
  end
  
  # Action after registration is submitted
  def register    
    @user = current_user

    respond_to do |format|
      unless params[:dob].blank? or params[:school].blank? or !params[:dob].match(/\A\d\d\d\d[-\/]?\d\d[-\/]?\d\d\z/)
        # Update user details based on submission
        @user.user_attributes = { :school => params[:school], :department => params[:department], :marli_renewal => ((params[:renewal]) ? "Renewal" : "New Applicant"), :affiliation_text => affiliation_text }
        @user.dob = params[:dob]
        @user.barcode = params[:barcode]
        @user.submitted_request = true
        @user.submitted_at = Time.now
        if @user.save
          # Send email
          RegistrationMailer.registration_email(@user).deliver
          format.html { redirect_to confirmation_url }
        else
          flash[:error] = t('registration.error')
          format.html { render :index_register }
        end
      else
        flash[:error] = t('registration.missing_fields')
        format.html { render :index_register }
      end 
    end

  end
end