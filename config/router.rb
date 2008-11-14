# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can specify conditions on the placeholder by passing a hash as the second
# argument of "match"
#
#   match("/registration/:course_name", :course_name => /^[a-z]{3,5}-\d{5}$/).
#     to(:controller => "registration")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  resources :users
  
  authenticate do
    resources :keywords
    resources :ads
    
    match('/keyword_tool', :method => :get).to(:controller => 'keyword_tool', :action => 'index').name("keyword_tool")
    match('/keyword_tool', :method => :post).to(:controller => 'keyword_tool', :action => 'search').name("search_keyword")
    
    match('/billing', :method => :get).to(:controller => 'billing', :action => 'index').name("billing")
    
    match('/settings', :method => :get).to(:controller => 'users', :action => 'edit').name("settings")
    match('/settings', :method => :put).to(:controller => 'users', :action => 'update')
  end
  
  match('/signup').to(:controller => 'users', :action => 'new')
  match('/login', :method => :get).redirect('/')
  match('/').to(:controller => 'home', :action => 'index')
  
  # Callback URL for Globe
  match('/globe').defer_to do |request, params|
    doc = Hpricot.XML(request.raw_post)
    xml_params = {}
    (doc/:param).each do |xml_param|
      xml_params[((xml_param/:name).inner_html).to_sym] = (xml_param/:value).innerHTML
    end
    # Basic checking that it's an SMS data
    if xml_params[:messageType] && xml_params[:messageType] == "SMS" &&
      xml_params[:msg] && xml_params[:source]
      
      if xml_params[:msg].match(/^\d{11}/)
        {:controller => "messages", :action => "create",
          :message => { :body => $', :receiver => $& }}
      elsif xml_params[:msg].match(/^STOP/i)
        {:controller => "subscribers", :action => "stop",
          :msisdn => xml_params[:source]}
      elsif xml_params[:msg].match(/^ALLOW/i)
        {:controller => "subscribers", :action => "allow",
          :msisdn => xml_params[:source]}
      else
        {:controller => "exceptions", :action => "not_found"}
      end
      
    else
      # not SMS
      {:controller => "exceptions", :action => "not_found"}
    end
  end
  
  # Adds the required routes for merb-auth using the password slice
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  # default_routes
end