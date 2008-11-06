class Billing < Application
  def index
    @ads = session.user.billable_ads
    @total_amount = session.user.bill_amount
    display @ads
  end
end
