# This class is defunct as the privileges guide app now drives the permissions to marli
# Will be removed in future versions
class PatronStatusesController < ApplicationController
  before_filter :authenticate_admin
   
  # GET /patron_statuses
  def index
    @patron_statuses = PatronStatus.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /patron_statuses/1
  def show
    @patron_status = PatronStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /patron_statuses/new
  def new
    @patron_status = PatronStatus.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /patron_statuses/1/edit
  def edit
    @patron_status = PatronStatus.find(params[:id])
  end

  # POST /patron_statuses
  def create
    @patron_status = PatronStatus.new(params[:patron_status])

    respond_to do |format|
      if @patron_status.save
        flash[:notice] = t('patron_statuses.create_success')
        format.html { redirect_to(@patron_status) }
      else
        format.html { render :new }
      end
    end
  end

  # PUT /patron_statuses/1
  def update
    @patron_status = PatronStatus.find(params[:id])

    respond_to do |format|
      if @patron_status.update_attributes(params[:patron_status])
        flash[:notice] = t('patron_statuses.update_success')
        format.html { redirect_to(@patron_status) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /patron_statuses/1
  def destroy
    @patron_status = PatronStatus.find(params[:id])
    @patron_status.destroy

    respond_to do |format|
      format.html { redirect_to(patron_statuses_url) }
    end
  end
end
