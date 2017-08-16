class Skill < ApplicationRecord

  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  has_many :comp_skills, dependent: :destroy
  has_many :competitions, through: :comp_skills

  has_many :team_skills, dependent: :destroy
  has_many :teams, through: :team_skills

  validates :name, :presence => true, uniqueness: true
  validates :category, :presence => true


  def duplicate
    Skill.where(name:self.name)
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
  # TODO rethink the scoring mechanism - LOOKS DONE
  def rank
    total_weight = 0.00
    skills = Skill.where(category:self.category)
    skills.each do |s|
      total_weight += s.weight
    end
    self.weight/total_weight
  end

  def self.skill_dist_indi
    data = []
    Skill.group(:category).count.each do |cat|
      set = {}
      set[:name] = cat[0]
      set[:data] = []
      Skill.where(category:cat).order(:category).joins(:users).group(:name, :category).count.each do |s,c|
        set[:data] << [s[0],c]
      end
      data << set
    end
    data
  end

  def self.skill_dist
    data = Skill.group(:category).count
    data.each do |k,v|
      data[k] = []
      skills = Skill.where(category:k)
      skills.each do |s|
        data[k] << s.users.collect{|u|u.id}
      end
      data[k] = data[k].flatten.uniq.count
    end
  end

end


