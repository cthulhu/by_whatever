#require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'

class ByWhateverTest < Test::Unit::TestCase
  load_schema

  class Account < ActiveRecord::Base
  end

  class User < ActiveRecord::Base
    by_whatever
  end
  
  class Category < ActiveRecord::Base
  end

  class Post < ActiveRecord::Base
    by_whatever :only => [:user_id]
  end
  
  class Comment < ActiveRecord::Base
    by_whatever :except => [:comment_id]
  end
  
  context "With applied by_whatever" do  
    context "User model" do  
      should "respond to :by_account_id" do
        assert_respond_to User, :by_account_id
      end
      context "with some data in the db" do
        setup do
          1..4.times do |index|
            User.create( :account_id => 1, :name => "User_#{index}_from_account_1" )
          end
          1..5.times do |index|
            User.create( :account_id => 2, :name => "User_#{index}_from_account_2" )
          end
        end
        should "return correct numbers due to scopes" do
          assert User.by_account_id(1).count == 4
          assert User.by_account_id(2).count == 5
          assert User.by_account_ids([2,1]).count == 9
        end
      end
    end
    
    context "Post model" do  
      should "respond to :by_user_id" do
        assert_respond_to Post, :by_user_id
      end
      should "not respond to :by_category_id" do
        assert !Post.respond_to?( :category_id )
      end
    end
    
    context "Comment model" do  
      should "respond to :by_user_id" do
        assert Comment.respond_to?( :by_user_id )
      end
      should "respond to :by_created_at" do
        assert Comment.respond_to?( :by_created_at )
      end      
      should "respond to :by_post_id" do
        assert Comment.respond_to?( :by_post_id )
      end
      should "not respond to :by_comment_id" do
        assert !Comment.respond_to?( :by_comment_id )
      end
    end
    [Comment, User, Post].each do |model_class|
      context "#{model_class.to_s} model" do
        [ 
          :during_last_minute, :during_last_hour, 
          :during_last_day, :during_last_week, 
          :during_last_month 
        ].each do |scope_name|
          should "respond_to :#{scope_name.to_s}" do
            assert model_class.respond_to?( scope_name )
          end
        end
      end
    end
  end
end
