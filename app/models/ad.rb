class Ad
  include DataMapper::Resource
  
  property :id,   Serial
  property :text, String, :length => 140
  
  belongs_to :user
  has n, :keywords, :through => Resource
  
  validates_present :text
  validates_length  :text, :max => 140
end
