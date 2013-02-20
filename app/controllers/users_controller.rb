class UsersController < ApplicationController
  respond_to :html, :js, :csv
  before_filter :authenticate_admin

  # GET /users
  def index
    @users = User.search(params[:q]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    respond_with(@user) do |format|
      format.csv { render :csv => @users, :filename => "marli_users_#{DateTime.now.strftime("%Y%m%d%H%m")}" }
    end
  end
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  # POST /users
  def create
    @user = User.new(:username => params[:user][:username], :email => params[:user][:email])
    @user.user_attributes = { :marli_admin => (params[:user][:marli_admin].to_i == 1), :marli_exception => (params[:user][:marli_exception].to_i == 1) }

    if @user.save
      flash[:notice] = t('users.create_success')
    end
    respond_with(@user)
  end
  
  # GET /patrons/1
  def show
    @user = User.find(params[:id])
  end

  # GET /patrons/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(:user_attributes => {:marli_admin => (params[:user][:marli_admin].to_i == 1), :marli_exception => (params[:user][:marli_exception].to_i == 1)})
      flash[:notice] = t('users.update_success')
    end
    respond_with(@user)
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
      @users = User.find(params[:id])
      @users.update_attributes( :submitted_request => nil, :submitted_at => nil )
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

  # Implement sort column function for this model
  def sort_column
    super "User", "lastname"
  end
  helper_method :sort_column
    
end
