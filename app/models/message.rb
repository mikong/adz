class Message
  include DataMapper::Resource
  
  property :id,       Serial
  property :body,     String, :length => 140
  property :receiver, String, :length => 11
  
  def matched_keywords
    words = self.body.split(/\W/).delete_if{|w| w.length < 3}.uniq
    keywords = []
    words.each do |word|
      keyword = Keyword.first(:word => word)
      keywords << keyword if keyword
    end
    keywords
  end
end
