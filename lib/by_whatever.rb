module ByWhatever

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # Default options:
    # :field => :id
    def by_whatever options = {}
      
    end
  end
end

ActiveRecord::Base.send :include, ByWhatever
