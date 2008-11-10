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
  
  def self.send_sms(options)
    @globe_proxy ||= Mobile::GlobeProxy.new(:username => GLOBE_API_USERNAME, :pin => GLOBE_API_PIN)
    response = @globe_proxy.send_sms(:to => options[:to], :message => options[:message])
    Merb.logger.warning("Send SMS Failed:\n#{options[:message]}") unless response.valid?
    return response
  end
  
  def send_sms(options={})
    options = {:to => receiver, :message => body}.merge(options)
    Message.send_sms(options)
  end
end
