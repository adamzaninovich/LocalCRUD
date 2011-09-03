class Item
  include Mongoid::Document
  
  attr_accessible :name, :location
  
  field :name
  field :latlng, :type => Array
  index [[ :latlng, Mongo::GEO2D ]]
  
  attr_writer :location
  def location
    unless self.latlng.nil?
      @location = self.latlng.join(', ')      
    end
    @location
  end
  
  validates :location, format: {
    with:         /\A-?\d+(.\d+)?, -?\d+(.\d+)?\z/,
    message:      'needs to be formatted like "38.0, -97.0"',
    allow_blank:  true
  }
  
  after_validation :prepare_latlng
  
  private
  def prepare_latlng
    unless @location.nil? or self.errors.messages.keys.include? :location
      self.latlng = @location.split(/,[ ]?/).map(&:to_f)
    end
  end
  
end
