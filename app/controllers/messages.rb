class Messages < Application
  # only_provides :xml
  
  def create(message)
    @message = Message.new(message)
    if @message.save
      message_to_send = @message.body
      keywords = @message.matched_keywords
      unless keywords.empty?
        ad = Ad.winner(keywords)
        message_to_send = ad.message_prefix + message_to_send if ad
      end
      Merb.logger.info("Sending: #{message_to_send}")
    else
      raise InternalServerError
    end
    return ''
  end

end
