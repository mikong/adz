class Messages < Application
  # only_provides :xml
  
  def create(message)
    @message = Message.new(message)
    if @message.save
      keywords = @message.matched_keywords
      ad = Ad.winner(keywords)
      if ad
        ad.serve_sms(@message)
      else
        @message.send_sms
      end
    else
      raise InternalServerError
    end
    return ''
  end

end
