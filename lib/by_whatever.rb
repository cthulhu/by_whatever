module ByWhatever

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # Default options:
    # :only => [:key1, ... ]
    # :only => [:key2, ... ]
    def by_whatever options = {}
      
    end
  end
end

ActiveRecord::Base.send :include, ByWhatever
