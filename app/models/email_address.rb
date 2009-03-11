# == Schema Information
# Schema version: 258
#
# Table name: email_addresses
#
#  id          :integer(11)   not null, primary key
#  address     :string(255)   
#  verified_at :datetime      
#  user_id     :integer(11)   
#  created_at  :datetime      
#  updated_at  :datetime      
#

class EmailAddress < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :address
  validates_uniqueness_of :address
  
  def verified?
    verified_at
  end
  
end
