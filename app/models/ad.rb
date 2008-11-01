class Ad
  include DataMapper::Resource
  
  property :id,   Serial
  property :text, String, :length => 140
  
  belongs_to :user
  has n, :keywordings
  has n, :keywords, :through => :keywordings
  
  validates_present :text
  validates_length  :text, :max => 140
  
  after :save, :save_word_list
  before :destroy, :destroy_all_keywordings
  
  def word_list
    @word_list || WordList.new(self.keywords.collect{|w| w.word}).to_s
  end
  
  def word_list=(value)
    @word_list = WordList.from(value)
  end
  
  protected
  
    def save_word_list
      return unless @word_list
      
      destroy_all_keywordings unless self.new_record?
      
      @word_list.each do |word|
        keyword = Keyword.find_or_create(word)
        Keywording.create(:keyword_id => keyword.id, :ad_id => self.id)
      end
      @word_list = nil
    end
    
    def destroy_all_keywordings
      self.keywordings.destroy!
    end
end
