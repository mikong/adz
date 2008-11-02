class KeywordTool < Application
  
  def index
    render
  end
  
  def search(keyword)
    @keyword = Keyword.first(:word => keyword)
    display @keyword
  end
  
end # KeywordTool
