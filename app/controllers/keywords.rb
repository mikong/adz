class Keywords < Application
  # provides :xml, :yaml, :js

  def index
    @keywords = Keyword.all
    display @keywords
  end

  def show(id)
    @keyword = Keyword.get(id)
    raise NotFound unless @keyword
    display @keyword
  end

  def new
    only_provides :html
    @keyword = Keyword.new
    display @keyword
  end

  def create(keyword)
    @keyword = Keyword.new(keyword)
    if @keyword.save
      redirect resource(@keyword), :message => {:notice => "Keyword was successfully created"}
    else
      message[:error] = "Keyword failed to be created"
      render :new
    end
  end

  def destroy(id)
    @keyword = Keyword.get(id)
    raise NotFound unless @keyword
    if @keyword.destroy
      redirect resource(:keywords)
    else
      raise InternalServerError
    end
  end

end # Keywords
