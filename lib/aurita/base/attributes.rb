
require('stringio')
require('tempfile')
Aurita.import('base/log/class_logger')

module Aurita

  class Attribute_Hash < Hash # :nodoc:

    def [](key)
      key = key.to_s

      direct_match = super(key) 
      return direct_match unless direct_match.nil?
      super(key.split('.')[-1])
    end

    alias :set :[]=

    def []=(key, value)
      set(key.to_s.intern, value)
      set(key.to_s, value)
    end

  end

  # Proxy class for accessing CGI request parameters. 
  # Most probably, you will not need to use this class directly as 
  # it is wrapped by helpers. (See Aurita::Main::Base_Controller#param)
  #
  # Model attributes can be named using a fully qualified 
  # attribute path, like
  #
  #    public.article.article_id
  #
  # Fully qualified attribute names reflect the name of 
  # attributes in the database, which is useful in many cases. 
  # Usually you don't use full attribute names yourself, but 
  # e.g. auto-generated forms use them to avoid naming 
  # conflicts. 
  #
  # As i don't want us to be forced to mind the database schema 
  # all along, Attributes allows adressing full attribute names 
  # implicitly, and there is no difference between Symbols and 
  # Strings for keys. 
  #
  # Example: 
  #
  #   a = Attributes.new('public.article.article_id' => 123, 
  #                      :content_id => 123, 
  #                      'page' => 2)
  #
  #   p a[:article_id]    -> "123"
  #   p a[:content_id]    -> "123"
  #   p a[:page]          -> "2"
  #
  #   a[:page] = 5
  #   p a[:page]          -> "5"
  #
  # Note that values are always returned as Strings. 
  # 
  class Attributes
    @@logger = Aurita::Log::Class_Logger.new('Attributes')
  
    # Initialize by passing a model klass that will use this 
    # Attribute instance, as well as CGI request object or 
    # key/value Hash. 
    #
    # Usage: 
    #
    #   params = Attributes.new(cgi_instance)
    # or:    
    #   params = Attributes.new(hash)
    #
    def initialize(attrib_hash) 
    # {{{

      @attributes     = Attribute_Hash.new
      @value_cache    = Hash.new
      touch

      if(attrib_hash.instance_of? Hash) then   attribs = attrib_hash
      else                                     attribs = attrib_hash.params
      end
      
      # write all attributes (unfiltered) to attrib pool: 
      implicit_name = ''
      resolved_value = ''
      attribs.each_pair { |name, value|
        if !name.nil? then
          resolved_value = Attributes::resolve_cgi_value(value)
          if name.to_s[-2..-1] == '[]' then
            name = name[0..-3]
            # Empty Array params should return an empty Array so 
            # param(:some_array_param).each { ... }
            # works as expected. 
            resolved_value = [] unless resolved_value 
          else
            resolved_value = resolved_value.first if resolved_value.is_a?(Array) 
          end
          @attributes[name] = resolved_value
          implicit_name = name.split('.')[2]
          if !implicit_name.nil? then 
            @attributes[implicit_name] = resolved_value
          end
        end
      }
    end # def }}}

    def +(attribs)
      @attributes.update(attribs) if attribs.kind_of? Hash
      touch
      return self
    end

    def self.resolve_cgi_value(value) # :nodoc:
    # {{{
      if(value.instance_of? Array) then
        if(value.first.instance_of?(StringIO) or value.first.instance_of?(Tempfile)) then
          value = value.map { |v| v = v.read } 
        end
      elsif(value.instance_of? StringIO or value.instance_of?(Tempfile)) then
        value = value.read
      end
      return value
    end # def }}}

    def each_pair(&block)
      @attributes.each_pair(&block)
    end

    # Delete attribute with given name. 
    #
    def delete(key)
      touch
      key = key.to_s
      @attributes.delete(key)
      @attributes.delete(key.intern)
    end

    # Whether a field is present in this Attribute instance.
    #
    def has_key?(key)
      @attributes.has_key?(key)
    end

    # Add attributes from key/value Hash. 
    #
    def update(other_hash)
      touch
      other_hash.each_pair { |k,v|
        set(k,v)
      }
    end

    # Returns all attributes specified in allowed_attribs_array. 
    # Useful when you have to allow attributes that are 
    # pre-filtered. 
    def only(allowed_attribs_array)
      filtered_attribs = Hash.new
      allowed_attribs_array.each { |attrib|
        filtered_attribs[attrib] = @attributes[attrib]
      }
      return filtered_attribs
    end
    
    # Returns empty string instead of nil. 
    # As Attributes objects are being passed to forms, 
    # these don't have to care about values being nil 
    # themselves. 
    def [](attribute_name)

      return @value_cache[attribute_name] if (!@touched && @value_cache[attribute_name])

      if attribute_name.nil? then return '' end

      value = nil
      attribute_name = attribute_name.to_s

      if @attributes[attribute_name].nil? then 
        short_attrib_name = attribute_name.split('.')[-1]
    
        if !@attributes[short_attrib_name].nil? then
          value = @attributes[short_attrib_name]
      
        else
          attrib_value = nil
          @attributes.each_pair { |key, value|
            key = key.to_s
            key_array          = key.split('.')
            implicit_attr_name = key_array[2]

            if !implicit_attr_name.nil? and implicit_attr_name == attribute_name then
              attrib_value = @attributes[key_array[0]+'.'+key_array[1]+'.'+attribute_name]
      #       break
            end
          }
          value = attrib_value 
        end
      
      else 
        value = @attributes[attribute_name]
      end

      @value_cache[attribute_name] = value
      return value

    end # def

    # Set / add an attribute value. 
    # Same as #set, but returns given value for 
    # compatibility with Enumberable. 
    def []=(name, value)
      set(name.to_s, value)
      touch
      value
    end
    
    # Set / add an attribute value. 
    def set(name, value)
      @attributes[name] = value
      @attributes[name.to_s] = value if name.kind_of? Symbol
      @attributes[name.intern] = value if name.kind_of? String
      touch
    end

    def inspect()
      r = ''
      @attributes.each { |k,v| r << "#{k.to_s} : #{v.to_s[0..30]}\n" }
      r
    end

    def hash
      @attributes
    end

    def touch
      @touched = true
    end

    def untouch
      @touched = false
    end

  end # class

end # module
