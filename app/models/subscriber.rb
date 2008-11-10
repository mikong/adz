class Subscriber
  include DataMapper::Resource
  
  property :id, Serial
  property :msisdn, String, :length => 11, :unique_index => true
  property :stopped, Boolean, :default => false
  
  def stop!
    return true if self.stopped?
    self.stopped = true
    save
  end
  
  def allow!
    return true unless self.stopped?
    self.stopped = false
    save
  end
end
