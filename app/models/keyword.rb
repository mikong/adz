class Keyword
  include DataMapper::Resource
  
  property :id,   Serial
  property :word, String, :length => 30

  has n, :keywordings
  has n, :ads, :through => :keywordings

  validates_present :word
  validates_length  :word, :within => 3..30
  validates_is_unique :word
  
  def self.find_or_create(keyword)
    first(:word => keyword) || create(:word => keyword)
  end
  
end
