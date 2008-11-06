class Users < Application
  
  before :ensure_authenticated, :only => [:edit, :update]
  
  def new
    only_provides :html
    @user = User.new
    display @user
  end
  
  def edit
    only_provides :html
    @user = session.user
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
  
  def update(user)
    @user = session.user
    if @user.update_attributes(user)
      redirect url(:settings), :message => {:notice => "Settings were successfully updated"}
    else
      display @user, :edit
    end
  end
end
