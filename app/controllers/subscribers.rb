class Subscribers < Application
  
  def stop
    @subscriber = Subscriber.first_or_create(:msisdn => params[:msisdn])
    Message.send_sms(:to => params[:msisdn], :message => MSG_STOPPED) if @subscriber.stop!
    return ''
  end
  
  def allow
    @subscriber = Subscriber.first_or_create(:msisdn => params[:msisdn])
    Message.send_sms(:to => params[:msisdn], :message => MSG_ALLOWED) if @subscriber.allow!
    return ''
  end
end
