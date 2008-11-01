class Keywording
  include DataMapper::Resource
  
  property :id, Serial
  
  belongs_to :ad
  belongs_to :keyword
end
