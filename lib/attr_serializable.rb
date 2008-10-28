module AttrSerializable
  
  def self.included(base) #:nodoc:
    base.extend ClassMethods
  end
  
  # For some reason, using :include and :only in to_xml takes the attributes from the :only options
  # and passes them along to each nested model. This method reogranizes the :include option to properly
  # call each nested model's to_xml with its respective attribute whitelist.
  def self.fix_includes(options = {})
    begin
      if options.keys.include?(:include) and options[:include].class.to_s == "Array"
        models = []
        options_include = {}

        options[:include].each do |key|
          klass = Kernel.const_get(key.to_s.classify)
          options_include[key] = {:only => klass.serializable_attributes}
        end
        
        return options_include
      else
        return options[:include]
      end
    rescue
      return options[:include]      
    end
  end
  
  module ClassMethods

    def attr_serializable(*attributes)
      write_inheritable_attribute("attr_serializable", attributes)
      class_eval "include AttrSerializable::InstanceMethods"
    end

    def serializable_attributes # :nodoc:
      read_inheritable_attribute("attr_serializable")
    end
    
  end
  
  module InstanceMethods
    
    def to_xml(options = {}) 
      options[:only] ||= self.class.serializable_attributes
      options[:include] = AttrSerializable.fix_includes(options)
      super(options)
    end
    
    def to_json(options = {}) 
      options[:only] ||= self.class.serializable_attributes
      super(options)
    end
    
  end
end
