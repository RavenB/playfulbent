# == Schema Information
#
# Table name: stories
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_on :datetime
#  updated_at :datetime
#

require File.dirname(__FILE__) + '/../unit_test_helper'

class StoryTest < Test::Unit::TestCase

  def test_first_page_text_defaults_to_empty_string
    assert_equal '', Story.new.first_page_text
  end
  
  def test_setting_first_page_text_creates_first_page
    story = Story.new
    story.first_page_text = 'banana'

    assert_equal 'banana', story.first_page_text    
    assert_equal 'banana', story.first_page_version.text    
  end
  
  def test_author_defaults_to_nil
    assert_equal nil, Story.new.author
  end
  
  def test_setting_author_creates_first_page
    story = Story.new
    user = User.new
    story.author = user

    assert_equal user, story.author
    assert_equal user, story.first_page_version.author
  end
  
  def test_first_page_has_no_parent
    story = Story.new
    assert_equal nil, story.first_page.parent
  end
  
  def test_first_page_has_this_stories_first_page_version
    story = Story.new
    version = PageVersion.new(:text => 'fish')
    story.first_page_version = version
    assert_equal [version], story.first_page.versions
  end
  
  def test_subscription_for_returns_new_subscription_if_one_not_found
    story = Story.new
    user = User.new
    user.stubs(:id).returns(45)
    subscription = story.subscription_for(user)
    assert subscription.is_a?(StorySubscription)
    assert subscription.new_record?
  end
  
  def test_subscription_returns_existing_subscription_if_exists
    story = Factory.create(:story)
    user = Factory.create(:user)
    subscription = Factory.create(:story_subscription, :story => story, :user => user)
        
    assert_equal subscription, story.subscription_for(user)
  end
  
    
end
