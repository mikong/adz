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
    xml_string = "<?xml version=\"1.0\" encoding=\"utf-8\"?>
                    <message>
                      <param>
                        <name>messageType</name>
                        <value>SMS</value>
                      </param>
                      <param>
                        <name>id</name>
                        <value>001</value>
                      </param>
                      <param>
                        <name>source</name>
                        <value>09179699677</value>
                      </param>
                      <param>
                        <name>target</name>
                        <value>23730244</value>
                      </param>
                      <param>
                        <name>msg</name>
                        <value>09179699677 Ok</value>
                      </param>
                      <param>
                        <name>udh</name>
                        <value></value>
                      </param>
                    </message>"
    # doc = Hpricot.XML(request.raw_post)
    doc = Hpricot.XML(xml_string)
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