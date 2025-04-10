class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  # GET /items or /items.json
  def index
    if params[:location_id]
      @items = current_user.items.where(location_id: params[:location_id])
    else
      @items = current_user.items # Show only bins for the logged-in user
    end
    # Apply search filtering if a name is provided
    @items = @items.search_by_name(params[:name])
  end

  # GET /items/1 or /items/1.json
  def show
    # list all possible bins for the item
    @bins = Bin.where(user_id: current_user.id)
  end

  # GET /items/new
  def new
    @item = Item.new
    @bins = current_user.bins
  end

  # GET /items/1/edit
  def edit
    @bins = current_user.bins  # Add this line to set @bins
  end

  # POST /items or /items.json
  # modify to ensure only can create items in bin
  # modify later for standalone items
  def create
    @item = current_user.items.build(item_params) 

    # Set no_bin to true if no bin is selected
    @item.no_bin = @item.bin_id.nil?

    if @item.save
      flash[:notice] = "Item was successfully created"  # ✅ Ensure this is set
      redirect_to items_path
    else
      @bins = current_user.bins  # Fetch bins again in case of error
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    # Set no_bin to true if bin_id is being removed/set to nil
    if params[:item][:bin_id].blank?
      params[:item][:no_bin] = true
    else
      params[:item][:no_bin] = false
    end

    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        @bins = current_user.bins
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.update!(bin_id: nil, no_bin: true)  # Combine both updates into one call
    respond_to do |format|
      format.html { 
        redirect_to items_path, 
        status: :see_other, 
        alert: "Warning: This item is not in any bin" 
      }
      format.json { render json: { status: :ok, message: "Item unassigned from bin" } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params.expect(:id))
    end

    def authorize_user
      if @item.bin.present? && @item.bin.user != current_user
        redirect_to items_path, alert: "Not authorized"
      end
    end
    
    
    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description, :value, :bin_id, :no_bin, item_pictures: [])
    end
end
