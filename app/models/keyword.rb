class Keyword
  include DataMapper::Resource
  
  property :id,   Serial
  property :word, String, :length => 30, :unique_index => true

  has n, :keywordings
  has n, :ads, :through => :keywordings

  validates_present :word
  validates_length  :word, :within => 3..30
  validates_is_unique :word
end
