class UsersController < ApplicationController
  respond_to :html, :js, :csv
  before_filter :authenticate_admin, :except => [:new_registration, :create_registration, :confirmation]
  before_filter :authorize_patron, :only => [:new_registration, :create_registration, :confirmation]
  before_filter :load_searchable_resource, :only => :index
  before_filter :preprocess_params, :only => :create_registration

  # GET /users
  def index
    respond_with(@users) do |format|
      format.csv { render :csv => User.search(params[:q]).order(sort_column + " " + sort_direction), :filename => "marli_users_#{DateTime.now.strftime("%Y%m%d%H%m")}" }
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

  # GET /users/1
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

  # DELETE /users/1
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
    redirect_to users_url
  end

  def new_registration
    @user = current_user
    respond_with(@user)
  end

  def create_registration
    @user = current_user
    @user.assign_attributes(user_params)
    @user.user_attributes[:department] = params[:user][:user_attributes][:department]
    @user.user_attributes[:school] = params[:user][:user_attributes][:school]
    @user.user_attributes[:marli_renewal] = params[:user][:user_attributes][:marli_renewal]
    @user.user_attributes[:affiliation_text] = params[:user][:user_attributes][:affiliation_text]

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
  def user_params
    params.require(:user).permit(:dob, :submitted_request, :submitted_at, :barcode)
  end

  def preprocess_params
    # This doesn't work unfortunately and saves two versions in the hash, for removal next update
    params[:user][:user_attributes].merge!({ :marli_renewal => ((!params[:user][:user_attributes][:marli_renewal].to_i.zero?) ? "Renewal" : "New Applicant"), :affiliation_text => affiliation_text })
    params[:user].merge!({:submitted_request => true, :submitted_at => Time.now})
  end

  def load_searchable_resource
    @users ||= User.search(params[:q]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
  end

  def marli_admin
    @marli_admin ||= (params[:user][:marli_admin].to_i == 1)
  end

  def marli_exception
    @marli_exception ||= (params[:user][:marli_exception].to_i == 1)
  end

end
