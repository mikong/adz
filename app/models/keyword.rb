class Keyword
  include DataMapper::Resource
  
  property :id,   Serial
  property :word, String, :length => 30

  has n, :ads, :through => Resource

  validates_present :word
  validates_length  :word, :within => 3..30
  validates_is_unique :word
end
