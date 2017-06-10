class Skill < ApplicationRecord

  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  has_many :comp_skills, dependent: :destroy
  has_many :competitions, through: :comp_skills

  validates :name, :presence => true, uniqueness: true
  validates :category, :presence => true


  def duplicate
    if Skill.where(name:self.name)
      true
      Rails.logger.debug('Triggered duplicate')
    else
      false
    end
  end

  def self.list_up
    order(category:'ASC').order(name:'ASC')
  end
  def self.list_down
    order(category:'DESC').order(name:'DESC')
  end
  def tag
    "#{name}, #{category}"
  end
  # TODO rethink the scoring mechanism
  def rank
    set = Skill.where(category:self.category) # All skills in category including self
    base = 0.0 # Sum of all weights: 100% mark
    set.each do |s|
      base += s.weight||1
    end
    (self.weight||1)/base # Return the [ x / (x+y+z) ] for individual rank
  end
end
