class UsersController < ApplicationController
  respond_to :html, :js, :csv
  before_filter :authenticate_admin, :except => [:new_registration, :create_registration, :confirmation]
  before_filter :authorize_patron, :only => [:new_registration, :create_registration, :confirmation]

  # GET /users
  def index
    @users = User.search(params[:q]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    
    respond_with(@users) do |format|
      format.csv { render :csv => @users, :filename => "marli_users_#{DateTime.now.strftime("%Y%m%d%H%m")}" }
    end
  end
  
  # GET /users/new
  def new
    @user = User.new
    respond_with(@user)
  end
  
  # POST /users
  def create
    @user = User.new(:username => params[:user][:username], :email => params[:user][:email])
    @user.user_attributes = { :marli_admin => marli_admin, :marli_exception => marli_exception }
    
    # Avoid redirecting to SSO
    flash[:notice] = t('users.create_success') if @user.save_without_session_maintenance
    respond_with(@user)
  end

  # GET /patrons/1
  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    flash[:notice] = t('users.update_success') if @user.update_attributes(:user_attributes => {:marli_admin => marli_admin, :marli_exception => marli_exception})
    respond_with(@user, :location => user_path(@user))
  end
  
  # DELETE /patrons/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    respond_with(@user)
  end
  
  # Reset submitted request flag 
  def reset_submissions
    if params[:id]
      @user = User.find(params[:id])
      @user.update_attributes( :submitted_request => nil, :submitted_at => nil )
    else
      @users = User.where(:submitted_request => true)
      @users.update_all( :submitted_request => nil, :submitted_at => nil )
    end

    flash[:success] = t('users.reset_submissions_success')
    respond_with(@users) do |format|
      format.html { redirect_to users_url }
    end
  end
  
  # Delete all non-admin patrons
  def clear_patron_data
    if User.destroy_all("user_attributes not like '%:marli_admin: true%'")
      flash[:success] = t('users.clear_patron_data_success')
    end
    respond_with(@user) do |format|
      format.html { redirect_to users_url }
    end
  end
  
  def new_registration   
    @user = current_user
    respond_with(@user)
  end
  
  def create_registration
    @user = current_user
    @user.user_attributes = { :school => params[:school], :department => params[:department], :marli_renewal => ((params[:renewal]) ? "Renewal" : "New Applicant"), :affiliation_text => affiliation_text }
    @user.dob = params[:dob]
    @user.barcode = params[:barcode]
    @user.submitted_request = true
    @user.submitted_at = Time.now

    respond_with(@user) do |format|
      if @user.save
        RegistrationMailer.registration_email(@user).deliver 
        format.html { redirect_to confirmation_url }
      else
        @user.submitted_request = false
        format.html { render :new_registration }
      end
    end
  end

  # Implement sort column function for this model
  def sort_column
    super "User", "lastname"
  end
  helper_method :sort_column
  
private
  
  def marli_admin
    @marli_admin ||= (params[:user][:marli_admin].to_i == 1)
  end
  
  def marli_exception
    @marli_exception ||= (params[:user][:marli_exception].to_i == 1)
  end
    
end
