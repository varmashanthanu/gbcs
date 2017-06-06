class Skill < ApplicationRecord

  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  has_many :comp_skills, dependent: :destroy
  has_many :competitions, through: :comp_skills

  validates :name, :presence => true, uniqueness: true
  validates :group, :presence => true

end
