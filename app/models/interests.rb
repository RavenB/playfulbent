# == Schema Information
#
# Table name: interests
#
#  id         :integer(4)      not null, primary key
#  profile_id :integer(4)
#

class Interests < ActiveRecord::Base
  belongs_to :profile
  validates_presence_of :profile
  acts_as_taggable

  after_update :update_profile_tags

protected

  def update_profile_tags
    unless profile.nil?
      profile.update_tags
    end
  end
  
end
