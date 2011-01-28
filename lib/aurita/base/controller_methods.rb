
require('lore')
require('aurita/base/exceptions')
require('aurita-gui/form')

Aurita.import_module :gui, :custom_form_elements
Aurita.import_module :gui, :button

module Aurita

  module Base_Controller_Methods

    # See Ruby's CGI.rb status header specifications 
    # (those do not respect HTTP specifications). 
    #
    HTTP_STATUS_CODES = { 302 => 'REDIRECT', 
                          200 => 'FOUND', 
                          400 => 'NOT_FOUND', 
                          401 => 'FORBIDDEN' }
    
    public

    # Wrapper for this controller's Aurita::Attributes 
    # instance 
    # Returns value for given request parameter name. 
    # 
    # Example: 
    # Request is 
    #
    #   [public.article.article_id] = 123
    #   [viewmode] = 'table'
    #
    #   param(:viewmode)     --> 'table'
    #   param(:article_id)   --> '123'
    #
    def param(key)
      @params[key]
    end

    def load(klass_name) # :nodoc:
    # {{{
      namespaces = klass_name.to_s.split('::')
      @klass     = Aurita.const_get(namespaces[0])
      namespaces[1..-1].each { |ns|
        @klass = @klass.const_get(ns)
      }
    end # def }}}

    protected

    # Raise an Aurita::User_Runtime_Error. 
    # Expects a language key to be translated for 
    # user interfaces. 
    #
    # Example: 
    #
    #    runtime_error(:username_already_exists)
    #
    # raises Exception with message
    #
    #    'This user name already exists. Please choose another one.'
    #
    def runtime_error(tag)
      raise Aurita::User_Runtime_Error.new(tag)
    end
    
    # Raise an Aurita::User_Runtime_Error. 
    # Expects a language key to be translated for 
    # user interfaces. 
    #
    # Usage: 
    #
    #   validation_error(User_Group.user_group_name => tl(:must_be_longer_than_3_characters), 
    #                    User_Login_Data.pass => tl(:must_contain_numbers))
    #
    # Example: 
    #
    #    runtime_error(:username_already_exists)
    #
    # raises Exception with message
    #
    #    'This user name already exists. Please choose another one.'
    #
    def validation_error(params={})
      klass = params[:model]
      klass = @klass unless klass
      params.each_pair { |clause,message|
        errors[clause.table_name] = Invalid_Parameters.new(clause.field_name => message)
      }
      raise Lore::Exception::Invalid_Klass_Parameters.new(klass, errors)
    end

    # Raise an Aurita::Type_Validation_Error. 
    # Expects a language key to be translated for 
    # user interfaces. 
    #
    # Usage: 
    #
    #   type_error(Content.created => tl(:must_be_timestamp), 
    #              Content.user_group_id => tl(:expected_integer))
    #
    def type_error(params)
      klass = params[:model]
      klass = @klass unless klass
      params.each_pair { |clause,message|
        # Resolve expected type by looking it up in model
        expected_type = klass.get_types[clause.to_s] 
        errors[clause.table_name] = Invalid_Types.new(clause.field_name => expected_type)
      }
      raise Lore::Exception::Invalid_Klass_Parameters.new(klass, errors)
    end

    # Updates attributes of model instance with values 
    # in request parameters (@params). 
    # Either a model instance to be updated is passed, 
    # or it is resolved using #load_instance. 
    #
    def update_instance(inst=nil)
    # {{{
      inst         ||= load_instance
      instance_attr  = inst.class.get_fields_flat
      ignored_params = [:action, :mode, :controller, :_session, :_request]
      log('Known attributes: ' << instance_attr.inspect)
      @params.each_pair { |param_name, param_value| 
        if param_name.to_s != '' && !(ignored_params.include?(param_name.to_sym)) then
          param_name = param_name.to_sym
          param_name_split = param_name.to_s.split('.').last.to_sym
          # only update attributes (that is: Skip primary keys)
          if instance_attr.include?(param_name)  then
            inst[param_name] = param_value
          elsif(instance_attr.include?(param_name_split)) then
            inst.set_attribute_value(param_name_split, param_value)
          else
            log('Ignoring ' << param_name.to_s << ' : ' << param_value.to_s)
          end
        end
      }
      return inst
    end # }}}

    public

    # Default implementation of creation routine on a 
    # business object. 
    #
    # If not overloaded, this method implements the following 
    # procedure: 
    #
    #   - Load model klass for this controller
    #   - Create a new instance of this model klass using 
    #     given request parameters (@params)
    #
    # As controller methods are invoced via App_Controller.call_guarded, 
    # errors are handled there. 
    #
    def perform_add() 
    # {{{
      @klass ||= resolve_model_klass()
      log { "perform_add on #{@klass.inspect} --> "}
      @instance = @klass.create(@params)
      log(@params.inspect)
      log { 'perform_add <--' }
      return @instance
    end # }}}
    
    # Default implementation of update routine on a 
    # business object. 
    #
    # If not overloaded, this method implements the following 
    # procedure: 
    #
    #   - Load model klass for this controller
    #   - Load instance from model klass, identified by primary 
    #     key attribute values in request parameters (@params). 
    #   - Update this instance using given request parameters (@params)
    #
    # As controller methods are invoced via App_Controller.call_guarded, 
    # errors are handled there. 
    #
    def perform_update() 
    # {{{
      @klass_instance = load_instance() 
      @klass_instance = update_instance(@klass_instance)
      @klass_instance.commit()
      return @klass_instance
    end # def }}}

    # Default implementation of deletion routine on a 
    # business object. 
    #
    # If not overloaded, this method implements the following 
    # procedure: 
    #
    #   - Load model klass for this controller
    #   - Load instance from model klass, identified by primary 
    #     key attribute values in request parameters (@params). 
    #   - Call this instance's delete method. 
    #
    # As controller methods are invoced via App_Controller.call_guarded, 
    # errors are handled there. 
    #
    def perform_delete() 
    # {{{
      @klass_instance = load_instance()
      @klass_instance.delete()
      @klass_instance = nil
    end # def }}}

    public

    # Set HTTP response header entries. 
    # Example: 
    #
    #   set_http_header('type' => 'application/x-pdf')
    #
    def set_http_header(args={})
      @response[:http_header] = {} unless @response[:http_header]
      @response[:http_header].update(args)
    end

    # Set an HTTP status code. 
    # Example: 
    #
    #   set_http_status(400)
    #
    #   set_http_status(302, 'Location' => 'http://somewhere.com')
    #
    # Note: Use method redirect_to for latter case. 
    #
    def set_http_status(status_code, params={})
      set_http_header('status_code' => status_code.to_s)
      status_code = HTTP_STATUS_CODES[status_code]
      set_http_header('status'      => status_code)
      set_http_header(params)
    end

    # Set HTTP response header entry for content type. 
    # Example: 
    #
    #   set_content_type('application/x-pdf')
    #
    def set_content_type(type)
      set_http_header('type' => type)
    end

    # Enforce HTTP caching of this request in the client's browser 
    # by setting HTTP headers 'Expires' and 'Last-Modified' 
    # appropriately. 
    def force_http_cache
      set_http_header('expires'       => (Time.now + (100 * 24 * 60 * 60)).to_s, 
                      'Last-Modified' => (Time.now - (1 * 24 * 60 * 60)).to_s)
    end

    # Forbid HTTP caching of this request in the client's browser 
    # by setting HTTP headers 'Expires' and 'Last-Modified' 
    # appropriately. 
    def no_http_cache
      set_http_header('expires'       => (Time.now - (1 * 24 * 60 * 60)).to_s,
                      'Last-Modified' => (Time.now).to_s, 
                      'pragma'        => 'No-cache')
    end

  protected

    def to_async_call_params(*args, &block)
      if args.at(0).is_a?(Symbol) then
        params   = args.at(1)
        params ||= {}
        params[:action] = args.at(0) 
      elsif args.at(0).is_a?(Aurita::Model) then
        entity = args.at(0)
        action = false
        if args.at(1).is_a?(Symbol) then
          params   = args.at(2)
          action   = args.at(1)
        else
          params = args.at(1)
        end
        params ||= {}
        params[:action]     = action unless params[:action]
        params[:controller] = entity.model_name
        params.update(:id => entity.key.values.first)
      else
        params = args.at(0)
      end
      params ||= {}
      params[:controller] = short_model_name() unless params[:controller]
      params[:action]     = params[:to] if params[:to]
      params[:action]     = :show unless params[:action]
      params.delete(:to)

      return params
    end

  public

    # Ajax redirect. 
    # Examples: 
    #
    # To redirect withing current controller: 
    #
    #   redirect_to(:action => :list)
    #
    #   redirect(:element => :some_element_dom_id, :to => :show)
    #
    # To redirect to another controller: 
    #   
    #   redirect_to(:controller => 'Other_Controller', :action => :show)
    #
    # Any parameter different from :controller, :action, :to, :element and :target
    # are used as GET parameters: 
    #
    #   redirect(:element => :some_element_dom_id, :to => :show, :product_id => 123)
    #
    # Redirecting using a model entity works like 
    #
    #   redirect_to(Article.get(234), :action => :update)
    #
    def redirect_to(*args)
    # {{{
      params = to_async_call_params(*args)
      
      onload = params[:onload]

      url = "#{params[:controller]}/#{params[:action]}/"
      target   = params[:target]
      target ||= params[:element]
      params.delete(:controller)
      params.delete(:action)
      params.delete(:target)
      params.delete(:element)
      params.delete(:onload)
      
      if params.size > 0 then
        get_params = []
        params.each_pair { |k,v|
          get_params << "#{k}=#{v}"
        }
      end

      call_target = ", element: '#{target}'" if target
      call_onload = ", onload: '#{onload}'" if onload

      url << get_params.join('&') if get_params

      exec_js("Aurita.load({ action: '#{url}' #{call_target}#{call_onload}});")
    end # }}}
    alias redirect redirect_to

    # Like #redirect, but inserting the request response after or before the given 
    # element with given DOM id, like: 
    #
    #   dom_insert(:after_element => 'header', 
    #              :controller    => 'Injecting_Controller', 
    #              :action        => :subheader)
    #
    # and respectively
    #
    #   dom_insert(:before_element => 'footer', 
    #              :controller     => 'Injecting_Controller', 
    #              :action         => :footer_head)
    #
    def dom_insert(*args)
      params = to_async_call_params(*args)
      
      onload = params[:onload]

      url = "#{params[:controller]}/#{params[:action]}/"
      target   = params[:target]
      target ||= params[:element]
      params.delete(:controller)
      params.delete(:action)
      params.delete(:target)
      params.delete(:element)
      params.delete(:onload)
      
      if params.size > 0 then
        get_params = []
        params.each_pair { |k,v|
          get_params << "#{k}=#{v}"
        }
      end

      call_onload = ", onload: '#{onload}'" if onload

      url << get_params.join('&') if get_params
    
      call_target = ''
      if params[:before_element] then
        target      = params[:before_element]
        call_target = ", before_element: '#{target}'"
      elsif params[:after_element] then
        target      = params[:after_element]
        call_target = ", after_element: '#{target}'" 
      end

      exec_js("Aurita.insert({ action: '#{url}' #{call_target}#{call_onload}});")
    end

    # Redirect to controller method or URL using an HTTP 302 
    # status code. 
    #
    # Examples: 
    #
    #   http_redirect_to('http://somewhere.com')
    #
    #   http_redirect_to(:controller => 'Wiki::Article', :action => :show, :id => 123)
    #
    # If no controller is given, this controller is assumed. 
    # So within Wiki::Article_Controller, you can also use: 
    #
    #   http_redirect_to(:action => :show, :id => 123)
    #
    # All result in an HTTP header entry like: 
    #
    #   HTTP/1.1 302 Found
    #   Location: http://yourserver.com/aurita/Wiki::Article/show/id=123
    #
    # In case you redirect to a method in this controller without 
    # passing any params, it's sufficient to only name the method 
    # (as Symbol): 
    #
    #   redirect_to(:list)
    #
    def http_redirect_to(target)
    # {{{
      url = ''
      if target.is_a?(Hash) then
        get_args = '' 
        target.each_pair { |k,v| 
          get_args << "#{k}=#{v}&" unless [ :controller, :action ].include?(k)
        }
        # Inherit decorator from original call
        target[:mode]       = param(:mode) unless target[:mode]
        target[:controller] = short_model_name unless target[:controller]
        url = "/aurita/#{target[:controller]}/#{target[:action]}/#{get_args}"
      elsif target.is_a?(String) then
        url = target
      elsif target.is_a?(Symbol) then
        url = "/aurita/#{short_model_name}/#{target}/"
      end
      set_http_status(302, { 'Location' => url })
    end # }}}

    # Upload a file from CGI multipart request. 
    # Example (file form field has name 'file_to_upload'): 
    #
    #   receive_file(param(:file_to_upload), 
    #                :relative_path      => :uploads, 
    #                :server_filename    => 'document')
    #
    # File would be uploaded to <project dir>/public/assets/tmp/uploads/document
    #
    # Returns a Hash with keys: 
    #
    #   :filesize          => Size of uploaded file in bytes
    #   :md5_checksum      => MD5 checksum of file content
    #   :original_filename => Name of original file uploaded
    #   :server_filename   => Name of this file on server
    #   :server_filepath   => Absolute file system path of file on server
    #   :type              => MIME type of uploaded file
    #
    def receive_file(file_upload_request, params={})
    # {{{
      
      relative_path      = params[:relative_path]
      server_filename    = params[:server_filename]
      md5_checksum       = false

      info = Hash.new

      begin

      # file_info         = @request.params[form_file_tag_name.to_s]
        file_info         = file_upload_request
        tmpfile           = file_info[:tempfile] 
        original_filename = file_info[:filename]
        filetype          = file_info[:type]

        path_from = nil
        original_filename = sanitize_filename(original_filename) 
        server_filename ||= original_filename

        # Fix permissions of tempfile in CGI's tmp/ directory: 
        path_from   = tmpfile.local_path if tmpfile.respond_to?(:local_path)
        path_from ||= tmpfile.path
        File.chmod(0777, path_from)
        
        path_to  = Aurita.project_path + '/public/assets/tmp/'
        path_to += relative_path+'/' if relative_path
        path_to += server_filename

        path_to.squeeze!('/')

        Aurita.log { 'UPLOAD: tmpfile ' << tmpfile.inspect } 
        Aurita.log { 'UPLOAD: path_to ' << path_to.inspect } 
        Aurita.log { 'UPLOAD: path from ' << path_to.inspect }
        Aurita.log { 'UPLOAD: filetype ' << filetype.inspect }
        
        info[:type]              = filetype
        info[:original_filename] = original_filename
        info[:server_filename]   = server_filename
        info[:server_filepath]   = path_to.to_s
        Aurita.log { 'UPLOAD: info ' << info.inspect } 

        if tmpfile.instance_of? Tempfile then
          FileUtils.copy(path_from, path_to)
        else 
          File.open(path_to.untaint, 'w') { |file| 
            File.chmod(0777, path_to)
            content      = tmpfile.string
            md5_checksum = Digest::MD5.hexdigest(content)
            file << content
          }
        end
        GC.enable
        GC.start
        GC.disable

        md5_checksum      ||= Digest::MD5.hexdigest(File.read(path_to.to_s))
        info[:filesize]     = File.size(path_to.to_s)
        info[:md5_checksum] = md5_checksum
      
        return info

      rescue => excep
        GC.enable
        GC.start
        GC.disable
        raise excep
      end
    end # }}} 

    def send_file(filepath, params={})
    # {{{
      filename   = params[:filename]
      filename ||= filepath.split('/').last
      filesize = 0
      case filepath
      when String then
         fs_path    = Aurita.project.base_path + '/public/' + filepath
         filesize   = File.size(fs_path)
         filename ||= File.basename(fs_path)
      when File then
         filesize   = file.size
         filename ||= file.basename
      end
      set_http_header('Content-Type'        => "application/force-download", 
                      'Content-Disposition' => "attachment; filename=\"#{filename}\"", 
                      'Content-Length'      => "#{filesize}", 
                      "X-Aurita-Sendfile"   => filepath, 
                      "X-Aurita-Filesize"   => "#{filesize}")
    end # }}} 

    private

    def sanitize_filename(str) # :nodoc:
      return str.split('/')[-1].split('\\')[-1].downcase.gsub(/(\s)+/,'_')
    end

    public

    # Returns an empty page. 
    # Useful for 
    #
    #   redirect_to :blank
    #
    def blank
      puts ' '
    end

    def show(klass=nil) 
    # {{{
      form = model_form(:model => klass, :instance => load_instance(klass))
      form.readonly! 
      puts form.string
    end # def }}}

    # Default method for adding a model instance. 
    # Renders Aurita::GUI::Form instance returned by #add_form(). 
    def add(klass=nil) 
    # {{{
      klass     = @klass if klass.nil?
      form      = model_form(:klass => @klass, :action => :perform_add)
      render_form(form)
    end # def }}}

    # Default method for updating a model instance. 
    # Renders Aurita::GUI::Form instance returned by #update_form(). 
    def update(klass=nil) 
    # {{{
      klass     = @klass if klass.nil?
      instance  = load_instance(klass)
      form      = model_form(:klass => @klass, :instance => instance, :action => :perform_update)
      render_form(form)
    end # def }}}

    # Default method for deleting a model instance. 
    # Renders Aurita::GUI::Form instance returned by #delete_form(). 
    def delete(klass=nil) 
    # {{{
      render_form(delete_form)
    end # def }}}

  end # class

end # module

