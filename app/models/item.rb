class Item
  include Mongoid::Document
  include Mongoid::Spacial::Document
  
  attr_accessible :name, :location
  
  field :name
  field :address
  field :coordinates, type: Array, spacial: true
  spacial_index :coordinates
  
  after_validation :prepare_coordinates
  
  attr_writer :location
  def location
    if @location.nil?
      unless self.coordinates.nil?
        @location = Item.hsh_to_loc(self.coordinates)
      end
    end
    @location
  end
  
  validates :name,      presence:true
  validates :location,  presence:false, 
                        format: {
    with:         /\A-?\d+(.\d+)?, -?\d+(.\d+)?\z/,
    message:      'needs to be formatted like "38.0, -97.0"',
    allow_blank:  true
  }
  
  def next
    Item.all.to_a[(Item.all.map(&:id).index(self.id) + 1) % Item.count]
  end
  
  def previous
    Item.all.to_a[(Item.all.map(&:id).index(self.id) - 1) % Item.count]
  end
  
  def self.loc_to_hsh(loc)
    lat,lng = loc.split(/,[ ]?/).map(&:to_f)
    { lat: lat, lng: lng }
  end
  
  def self.hsh_to_loc(hsh)
    "#{hsh[:lat]}, #{hsh[:lng]}"
  end
  
  private
  def prepare_coordinates
    unless @location.nil? or self.errors.messages.keys.include? :location
      self.coordinates = Item.loc_to_hsh(@location)
    end
  end
  
end
