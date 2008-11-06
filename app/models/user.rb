# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
#
# Don't forget that by default the salted_user mixin is used from merb-more
# You'll need to setup your db as per the salted_user mixin, and you'll need
# To use :password, and :password_confirmation when creating a user
#
# see merb/merb-auth/setup.rb to see how to disable the salted_user mixin
# 
# You will need to setup your database and create a user.
class User
  include DataMapper::Resource
  
  property :id,     Serial
  property :login,  String
  property :created_at, DateTime
  property :updated_at, DateTime
  
  property :budget, Integer, :default => 0
  
  has n, :ads
  
  validates_length       :login,                :within => 3..40
  validates_is_unique    :login
  validates_length       :password,             :within => 4..40, :if => :password_required?
  
  validates_is_number    :budget
  validates_with_method  :check_budget
  
  def check_budget
    return true if self.budget.nil?
    if self.budget >= 0
      return true
    else
      [false, "Budget must be a positive number"]
    end
  end
  
  # returns all ads including deleted ones
  def billable_ads
    Ad.find_by_sql(["SELECT * FROM ads WHERE user_id = ?", self.id])
  end
  
  def bill_amount
    total_amount = 0
    self.ads.each {|ad| total_amount += ad.hits}
    return total_amount
  end
end
