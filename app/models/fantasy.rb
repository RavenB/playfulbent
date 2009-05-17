# == Schema Information
# Schema version: 258
#
# Table name: fantasies
#
#  id          :integer(11)   not null, primary key
#  description :text          
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Fantasy < ActiveRecord::Base
  has_many :roles, :dependent => :destroy, :class_name => 'FantasyRole'
  belongs_to :creator, :class_name => 'User'
  
  validates_presence_of :creator, :description
  validate :requires_first_person_pronoun
  
  def description=(value)
    write_attribute :description, value
    calculate_roles
  end
  
  protected
  
    def calculate_roles
      roles.clear
      add_first_person_role if creator && has_first_person_pronoun?
      add_third_person_roles unless description.blank?
    end
    
    def add_first_person_role
      roles << FantasyRole.new_first_person(creator)
    end
    
    def add_third_person_roles
      for name in bracketted_names
        roles << FantasyRole.new(:name => name)
      end
    end
    
    def bracketted_names
      description.scan(/\[([^\]]*)\]/).map(&:first).map(&:strip).uniq.reject do |name|
        is_first_person?(name)
      end
    end
    
    def is_first_person?(name)
      name =~ /^(i|me|i'm|i've)$/
    end
  
    def has_first_person_pronoun?
      description && description =~ /([ \n\[]|^)(i|me|i'm|i've)([ \n]|$)/i
    end
  
    def requires_first_person_pronoun
      unless has_first_person_pronoun?
        errors.add(:description, 'must include a first person pronoun. Try using a word like "I" or "me"')
      end
    end
  
end