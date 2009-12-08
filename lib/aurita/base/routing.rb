
module Aurita

  # Rewrite from 
  #
  #   <host>/aurita/Foo/bar[/param1=value&param2=value]
  #
  # to
  #
  #   <host>/aurita/?controller=Foo&action=bar[&param_1=value&param_2=value]
  #
  class Routing

    def route(env)
    # {{{
      uri   = env['REQUEST_URI']
      uri ||= env['PATH_INFO']
      # Poor man's routing: 
      routed = false
      uri_p  = uri.split('/')

      if !uri.include?('?') then
        if uri_p.length >= 4 && uri_p[3].to_i.to_s == uri_p[3]
          # host/aurita/Controller/1234/[action]
          host       = uri_p[0]
          controller = uri_p[2]
          action     = uri_p[4]
          action   ||= 'show'
          get_params = "id=#{uri_p[3]}"
          routed = true
        elsif uri_p.length >= 4 then
          # host/aurita/Controller/action/[param=value]
          host       = uri_p[0]
          controller = uri_p[2]
          action     = uri_p[3]
          get_params = uri_p[4]
          routed = true
        end
      end
      # Only if X-Sendfile is available
      if false && uri_p[2] == 'assets' && uri_p.length == 4
        host       = uri_p[0]
        controller = 'Wiki::Media_Asset'
        action     = 'proxy'
        m_id       = uri_p[3].gsub(/asset_([^\.])\.(.+)/,'\1')
        get_params = "media_asset_id=#{m_id}"
        routed = true
      end
      
      if routed then
        query = "controller=#{controller}&action=#{action}&#{get_params}"
        path  = "/aurita/run?#{query}"
        uri   = "#{host}#{path}"
        env['REQUEST_URI']  = uri
        env['REQUEST_PATH'] = path
        env['QUERY_STRING'] = query
      end

      return env
    end # }}}

  end

end
