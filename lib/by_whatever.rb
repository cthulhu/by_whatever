module ByWhatever

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # Default options:
    # :only => [:key1, ... ]
    # :except => [:key2, ... ]
    def by_whatever options = {}
      model_columns = self.columns.map{|clmn| [clmn.name, clmn.type]}
      
      model_columns = model_columns.select{|clmn| options[:only].include?( clmn[0].to_sym ) } unless options[:only].blank?
      model_columns = model_columns.reject{|clmn| options[:except].include?( clmn[0].to_sym ) } unless options[:except].blank?
      
      self.class_eval do 
        unless model_columns.blank?
          model_columns.each do |column|
            named_scope "by_#{column[0]}".to_sym,lambda { |value|
             (value.blank?) ? {} : { :conditions => ['#{column[0]} = ?', value] }
            }
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ByWhatever
