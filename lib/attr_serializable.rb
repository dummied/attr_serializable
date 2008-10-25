module AttrSerializable
  
  def self.included(base) #:nodoc:
    base.extend ClassMethods
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
      super(options)
    end
    
    def to_json(options = {}) 
      options[:only] ||= self.class.serializable_attributes
      super(options)
    end
    
  end
end
