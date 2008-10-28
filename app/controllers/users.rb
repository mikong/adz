class Users < Application
  
  def new
    only_provides :html
    @user = User.new(params[:user] || {})
    display @user
  end
  
  def create(user)
    session.abandon!
    
    @user = User.new(user)
    if @user.save
      redirect "/", :message => {:notice => "Signup complete"}
    else
      message[:error] = "Signup failed"
      render :new
    end
  end
  
end
