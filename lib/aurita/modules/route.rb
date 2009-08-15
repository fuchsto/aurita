
module Aurita

  class Routing_Error < ::Exception
    def initialize(excep)
      @message = 'Routing error. Original exception message was: ' << excep.backtrace.join("\n")
      @backtrace << excep.backtrace
    end
  end

  # Provides RESTful mapping from URL scheme to controller calls. 
  # Routes usually are added in aurita_project/routes.rb, which is 
  # required by Aurita::Dispatcher automatically. 
  #
  # Usage: 
  #
  #   Route.add(:name => :article, 
  #             :params => [ :article_id, :view ], 
  #             :controller => 'Wiki::Article', 
  #             :action => :show, 
  #             :method => :GET)
  #   Route.add(:name => :article, 
  #             :controller => 'Wiki::Article', 
  #             :action => :create, 
  #             :method => :POST)
  #   Route.add(:name => :article, 
  #             :controller => 'Wiki::Article', 
  #             :action => :update, 
  #             :method => :PUT)
  #   Route.add(:name => :article, 
  #             :controller => 'Wiki::Article', 
  #             :action => :delete, 
  #             :method => :DELETE)
  #
  # Route.resolve is used to transform an HTTP request to dispatcher 
  # parameters. 
  # 
  #   Route.resolve('article/id=123/v=full', :GET)
  #    --> {:action=>:show, :param_values=>{:article_id=>"123", :view=>"full"}, :params=>[:article_id, :view], :controller=>"Wiki::Article"}
  #   Route.resolve('article', :POST)
  #    --> {:action=>:create, :param_values=>{}, :controller=>"Wiki::Article"}
  #
  class Route

    @@routes = {}

    # Usage: 
    # (in aurita_project/routes.rb)
    #
    #   Route.add(:name => :article, 
    #             :params => [ :article_id, :viewparams ], 
    #             :controller => Wiki::Article_Controller
    #             :method => :show)
    #
    # Effect: 
    #   '/aurita/article/123/full' 
    # and
    #   '/aurita/article/article_id=123/view=full' 
    # will be dispatched like
    #   '/aurita/Wiki::Article/article_id=123&viewparams=full'
    #
    # Parameters (:params) are optional. 
    #
    def self.add(routing_params)
      route_name = routing_params[:name]
      routing_params.delete(:name)
      http_method = routing_params[:method]
      http_method = :GET unless http_method
      routing_params.delete(:method)
      @@routes[route_name] = Hash.new unless @@routes[route_name]
      @@routes[route_name][http_method] = routing_params 
    end
    
    # Transforms url to dispatcher params, according to 
    # previously configured routes (see Aurita::Main::Route.add). 
    # Every parameter will be threated as optional: 
    #
    #  '/aurita/article/123' => { :controller => Wiki::Article, 
    #                             :method => 'show', 
    #                             :param_values => { :article_id => 123 } )
    #  '/aurita/article/123' => { :controller => Wiki::Article, 
    #                             :method => 'show', 
    #                             :param_values => { :article_id => 123, :view => 'full' } )
    #
    def self.resolve(original_url, http_method=:GET)
      request    = original_url.split('/')
      route_name = request[0].intern
      dispatcher_params = @@routes[route_name][http_method]
      dispatcher_params[:param_values] = {}
      return dispatcher_params unless dispatcher_params[:params]

      for param_idx in 0..dispatcher_params[:params].length do 
        param_value = request[param_idx+1]
        if param_value then
          param_value = param_value.split('=').last # returns param if no '=' included
          param_name  = dispatcher_params[:params][param_idx]
          dispatcher_params[:param_values][param_name] = param_value
        end
      end
      return dispatcher_params
    end
  end

end


