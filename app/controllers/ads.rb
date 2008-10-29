class Ads < Application

  def index
    @ads = session.user.ads
    display @ads
  end

  def show(id)
    @ad = session.user.ads.first(:id => id)
    raise NotFound unless @ad
    display @ad
  end

  def new
    only_provides :html
    @ad = session.user.ads.build
    display @ad
  end

  def edit(id)
    only_provides :html
    @ad = session.user.ads.first(:id => id)
    raise NotFound unless @ad
    display @ad
  end

  def create(ad)
    @ad = session.user.ads.build(ad)
    if @ad.save
      redirect resource(@ad), :message => {:notice => "Ad was successfully created"}
    else
      message[:error] = "Ad failed to be created"
      render :new
    end
  end

  def update(id, ad)
    @ad = session.user.ads.first(:id => id)
    raise NotFound unless @ad
    if @ad.update_attributes(ad)
      redirect resource(@ad)
    else
      display @ad, :edit
    end
  end

  def destroy(id)
    @ad = session.user.ads.first(:id => id)
    raise NotFound unless @ad
    if @ad.destroy
      redirect resource(:ads)
    else
      raise InternalServerError
    end
  end

end # Ads
