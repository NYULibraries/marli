class UsersController < ApplicationController
  respond_to :html, :js, :csv
  before_action :authenticate_admin, :except => [:new_registration, :create_registration, :confirmation]
  before_action :authorize_patron, :only => [:new_registration, :create_registration, :confirmation]

  # GET /users
  def index
    @users = User.all.order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    @users = @users.with_query(params[:q]) if params[:q]
    respond_with(@users) do |format|
      format.csv { render :csv => User.all, :filename => "marli_users_#{DateTime.now.strftime("%Y%m%d%H%m")}" }
    end
  end

  # GET /users/new
  def new
    @user = User.new
    respond_with(@user)
  end

  # POST /users
  def create
    @user = User.new( username: user_params[:username], email: user_params[:email],
                      admin: admin, override_access: override_access)
    flash.now[:notice] = t('users.create_success') if @user.save
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

    flash.now[:notice] = t('users.update_success') if @user.update_attributes(admin: admin, override_access: override_access)
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
    if params[:id].present?
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
    if User.where(admin: [nil, false]).destroy_all
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
    @user.marli_renewal = (!user_params[:marli_renewal].to_i.zero?) ? "Renewal" : "New Applicant"
    @user.affiliation_text = affiliation_text
    @user.submitted_request = true
    @user.submitted_at = Time.now
    @user.validate_fields = true

    respond_with(@user) do |format|
      if @user.save
        RegistrationMailer.registration_email(@user).deliver_now
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
    params.require(:user).permit(:username, :email, :submitted_request, :submitted_at, :barcode, :marli_renewal, :affiliation_text, :override_access, :admin)
  end

  def admin
    @admin ||= (user_params[:admin].to_i == 1)
  end

  def override_access
    @override_access ||= (user_params[:override_access].to_i == 1)
  end

end
