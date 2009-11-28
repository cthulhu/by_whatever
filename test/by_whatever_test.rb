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
    end
    
    context "Post model" do  
      should "respond to :by_user_id" do
        assert_respond_to User, :by_user_id
      end
      should "not respond to :by_category_id" do
        assert_not_respond_to User, :category_id
      end
    end
    
    context "Comment model" do  
      should "respond to :by_user_id" do
        assert_respond_to User, :by_user_id
      end
      should "respond to :by_post_id" do
        assert_not_respond_to User, :by_post_id
      end
      should "not respond to :by_comment_id" do
        assert_not_respond_to User, :by_comment_id
      end
      
    end

  end
  
end
