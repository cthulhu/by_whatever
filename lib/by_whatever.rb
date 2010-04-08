module ByWhatever

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # Default options:
    # :only   => [:key1, ... ]
    # :except => [:key2, ... ]
    def by_whatever options = {}
      # This exeptions throw when table is not constructed yet
      begin 
        model_columns = self.columns.map{|clmn| [clmn.name, clmn.type]}
        table_name = self.table_name
      rescue => e
        self.logger.info "By Whatever exception: #{e.to_s}"
        self.logger.info e.backtrace
      end

      model_columns = model_columns.select{|clmn| options[:only].include?( clmn[0].to_sym ) } unless options[:only].blank?
      model_columns = model_columns.select{|clmn| !options[:except].include?( clmn[0].to_sym ) } unless options[:except].blank?

      self.class_eval do 
        unless model_columns.blank?
          model_columns.each do |column|
            named_scope "by_#{column[0]}".to_sym,lambda { |value|
             (value.blank?) ? {} : { :conditions => sanitize_sql_for_conditions( ["#{table_name}.#{column[0]} = ?", value] ) }
            }
            named_scope "by_#{column[0]}s".to_sym,lambda { |value|
             (value.blank? || !value.is_a?( Array )) ? {} : { :conditions => sanitize_sql_for_conditions( ["#{table_name}.#{column[0]} IN ( ? )", value] ) }
            }
          end
          named_scope :during_last_minute, lambda{{ :conditions => [ 'created_at >= ?', (Time.now.utc - 1.minute ).to_s(:db) ] }}
          named_scope :during_last_hour,   lambda{{ :conditions => [ 'created_at >= ?', (Time.now.utc - 1.hour ).to_s(:db) ] }}
          named_scope :during_last_day,    lambda{{ :conditions => [ 'created_at >= ?', (Time.now.utc - 1.day ).to_s(:db) ] }}
          named_scope :during_last_week,   lambda{{ :conditions => [ 'created_at >= ?', (Time.now.utc - 1.week ).to_s(:db) ] }}
          named_scope :during_last_month,  lambda{{ :conditions => [ 'created_at >= ?', (Time.now.utc - 1.month ).to_s(:db) ] }}
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ByWhatever
