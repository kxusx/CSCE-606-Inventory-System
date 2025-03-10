class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [:update, :destroy]

  # GET /locations
  def index
    @locations = current_user.locations
    @location = Location.new
    if params[:name].present?
      @locations = @locations.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
    end

    if request.xhr?
      render partial: "locations_table", locals: { locations: @locations }, layout: false
    else
      render :index
    end
  end

  # POST /locations
  def create
    @location = current_user.locations.new(location_params)
    if @location.save
      flash[:notice] = "Location created successfully!"
      redirect_to locations_path
    else
      flash[:alert] = "Failed to create location"
      redirect_to locations_path
    end
  end

  # PATCH/PUT /locations/:id
  def update
    if @location.update(location_params)
      flash[:notice] = "Location updated successfully!"
      redirect_to locations_path
    else
      flash[:alert] = "Failed to update location"
      redirect_to locations_path
    end
  end

  # DELETE /locations/:id
  def destroy

    Thread.current[:deletion_context] = :from_locations
    
    if @location.destroy
      flash[:notice] = "Location deleted successfully!"
    else
      flash[:alert] = "Failed to delete location"
    end

    Thread.current[:deletion_context] = nil
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
