require 'attr_serializable'
ActiveRecord::Base.class_eval { include AttrSerializable }
