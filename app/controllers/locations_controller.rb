class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  def index
    @locations = current_user.locations
    
    if params[:name].present?
      @locations = @locations.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
    end
  
    if request.xhr?
      render partial: "locations_table", locals: { locations: @locations }, layout: false
    else
      render :index
    end
  end

  # GET /locations/:id
  def show
  end

  # GET /locations/new
  def new
    @location = current_user.locations.new
  end

  # POST /locations
  def create
    @location = current_user.locations.new(location_params)
    if @location.save
      flash[:notice] = "Location created successfully!"
      redirect_to locations_path
    else
      flash.now[:alert] = "Failed to create location"
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
      end
    end
  end

  # GET /locations/:id/edit
  def edit
  end

  # PATCH/PUT /locations/:id
  def update
    if @location.update(location_params)
      flash[:notice] = "Location updated successfully!"
      redirect_to locations_path
    else
      flash[:alert] = "Failed to update location"
      render :edit
    end
  end

  # DELETE /locations/:id
  def destroy
    @location.destroy
    flash[:notice] = "Location deleted successfully!"
    redirect_to locations_path
  end

  private

  def set_location
    @location = current_user.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name)
  end
end
