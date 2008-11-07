class Ad
  include DataMapper::Resource
  
  property :id,      Serial
  property :sponsor, String, :length => (0..24), :nullable => false
  property :text,    String, :length => (0..140)
  property :hits,    Integer, :default => 0
  property :budget,  Integer
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime
  
  belongs_to :user
  has n, :keywordings
  has n, :keywords, :through => :keywordings
  
  validates_is_number :budget
  validates_with_method :validate_budget
  
  after :save, :save_word_list
  before :destroy, :destroy_all_keywordings
  
  def validate_budget
    return true if self.budget.nil?
    if self.budget >= 0
      return true
    else
      [false, "Budget must be a positive number"]
    end
  end
  
  def budget
    if new_record? && user
      @budget ||= user.budget_per_ad
    else
      @budget
    end
  end
  
  def self.liquid
    all(:conditions => ["budget > hits"])
  end
  
  def message_prefix
    "This message is sponsored by #{sponsor}:"
  end
  
  def next_hit
    self.hits = self.hits + 1
  end
  
  def serve_sms(message)
    response = message.send_sms(:message => self.message_prefix + message.body)
    if response.valid?
      next_hit
      unless self.text.blank? || (self.hits >= self.budget)
        response = message.send_sms(:message => self.text)
        next_hit if response.valid?
      end
      save
    end
  end
  
  def word_list
    @word_list || WordList.new(self.keywords.collect{|w| w.word}).to_s
  end
  
  def word_list=(value)
    @word_list = WordList.from(value)
  end
  
  # Point system: (lower is better)
  #   Keyword ranking:
  #     less associated ads, the better
  #     points = no. of ads associated
  #   Ad ranking:
  #     earlier and higher matched:unmatched keywords ratio, better
  #     points = punctuality rank + total keywords + previous hits # - matched keywords
  #   Note:
  #     All things being equal, randomize. (:order => 'RAND()')
  def self.winner(words)
    return if words.nil? || words.empty?
    
    word_pts = {}
    words.each {|w| word_pts[w.id] = w.ads.liquid.count}
    word_pts.delete_if {|key,value| value == 0}
    return if word_pts.empty? # no ads, no winner
    winning_keyword_id = word_pts.sort {|a,b| a[1]<=>b[1]}[0][0]
    
    # Note: This SQL actually returns duplicates depending on number of matched keywords,
    #       but find_by_sql returns an array without duplicates.
    ads = Ad.find_by_sql(["SELECT a.* FROM ads a, keywordings b, keywords c
                           WHERE a.id = b.ad_id AND b.keyword_id = c.id
                           AND c.id = ? AND a.budget > a.hits ORDER BY updated_at", winning_keyword_id])
    ad_pts = {}
    ads.each_with_index {|ad,index| ad_pts[ad.id] = index + ad.keywords.count + ad.hits}
    winning_ad_id = ad_pts.sort {|a,b| a[1]<=>b[1]}[0][0]
    get(winning_ad_id)
  end
  
  protected
  
    def save_word_list
      return unless @word_list
      
      destroy_all_keywordings unless self.new_record?
      
      @word_list.each do |word|
        keyword = Keyword.first_or_create(:word => word)
        Keywording.create(:keyword_id => keyword.id, :ad_id => self.id)
      end
      @word_list = nil
    end
    
    def destroy_all_keywordings
      self.keywordings.destroy!
    end
end
