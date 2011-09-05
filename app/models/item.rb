class Item
  include Mongoid::Document
  
  attr_accessible :name, :location
  
  field :name
  field :latlng, type: Array
  index [[ :latlng, Mongo::GEO2D ]]
  
  attr_writer :location
  def location
    if @location.nil?
      unless self.latlng.nil?
        @location = self.latlng.join(', ')
      end
    end
    @location
  end
  
  validates :name,      presence:true
  validates :location,  presence:true, 
                        format: {
    with:         /\A-?\d+(.\d+)?, -?\d+(.\d+)?\z/,
    message:      'needs to be formatted like "38.0, -97.0"',
    allow_blank:  false
  }
  
  after_validation :prepare_latlng
  
  def next
    Item.all.to_a[(Item.all.map(&:id).index(self.id) + 1) % Item.count]
  end
  
  def previous
    Item.all.to_a[(Item.all.map(&:id).index(self.id) - 1) % Item.count]
  end
  
  private
  def prepare_latlng
    unless @location.nil? or self.errors.messages.keys.include? :location
      self.latlng = @location.split(/,[ ]?/).map(&:to_f)
    end
  end
  
end
