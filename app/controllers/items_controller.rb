class ItemsController < ApplicationController
  # GET /items
  # GET /items.json
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end
  
  # GET /nearby.json?lat=xx.xxx&lng=-xxx.xx&ft=20
  def nearby
    lat,lng,ft = params[:lat].to_f, params[:lng].to_f, (params[:ft].nil? ? 5280 : params[:ft].to_f)
    @items = Item.geo_near(
      lat:          lat,
      lng:          lng,
      max_distance: ft,
      unit:         :ft,
      spherical:    true
    ).map do |item|
      distance = Geocoder::Calculations.distance_between(
        [ lat, lng ],
        [ item.coordinates[:lat], item.coordinates[:lng] ],
        units: :mi
      ) * 5280.0
      if distance <= ft
        {
          name:         item.name,
          coordinates:  item.coordinates,
          distance:     distance
        }
      else
        nil
      end
    end.compact
    
    render json: {
      params: {
        lat:lat,
        lng:lng,
        ft:ft
      },
      items:  @items
    }
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])
    
    puts @item.inspect
    puts params.inspect 
    
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :ok }
    end
  end
end
