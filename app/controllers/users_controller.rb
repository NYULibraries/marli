class UsersController < ApplicationController
  before_filter :authenticate_admin

  # GET /users
  def index
    @users = User.search(params[:q]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    
    respond_to do |format|
      format.html
      format.csv { render :csv => @users, :filename => "marli_users" }
    end
  end
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  # POST /users
  def create
    @user = User.new
    @user.username = params[:user][:username]
    @user.email = params[:user][:email]
    @user.user_attributes = {}
    @user.user_attributes[:marli_admin] = params[:user][:marli_admin].to_i == 1
    @user.user_attributes[:marli_exception] = params[:user][:marli_exception].to_i == 1

    respond_to do |format|
      if @user.save
        flash[:notice] = t('users.create_success')
        format.html { redirect_to users_url }
      else
        format.html { render :new }
      end
    end
  end
  
  # GET /patrons/1
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /patrons/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    user_attributes = {}
    user_attributes[:marli_admin] = params[:user][:marli_admin].to_i == 1
    user_attributes[:marli_exception] = params[:user][:marli_exception].to_i == 1
    @user.update_attributes(:user_attributes => user_attributes)

    respond_to do |format|
      flash[:notice] = t('users.update_success')
      format.js { render :layout => false }
      format.html { redirect_to(@user) }
    end
  end
  
  # DELETE /patrons/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
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
    redirect_to users_url
  end
  
  # Delete all non-admin patrons
  def clear_patron_data
    User.destroy_all("user_attributes not like '%:marli_admin: true%'")
    flash[:success] = t('users.clear_patron_data_success')
    redirect_to users_url
  end

  # Implement sort column function for this model
  def sort_column
    super "User", "lastname"
  end
  helper_method :sort_column
    
end
