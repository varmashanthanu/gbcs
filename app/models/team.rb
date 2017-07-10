class Team < ApplicationRecord

  attr_accessor :comp_teams_attributes, :members_attributes
  validates :name, presence: true

  has_many :members, dependent: :destroy
  has_many :users, through: :members
  # accepts_nested_attributes_for :members, reject_if: proc { |attributes| attributes[:user_id].blank? }, allow_destroy: true

  has_many :comp_teams, dependent: :destroy
  has_many :competitions, through: :comp_teams
  accepts_nested_attributes_for :comp_teams, allow_destroy: true, reject_if: proc { |attributes| attributes[:competition_id].blank? }

  has_many :team_skills, dependent: :destroy
  has_many :skills, through: :team_skills

  has_many :invites, dependent: :destroy

  def self.mine(user)
    where(:id=>Member.where(user:user).select(:team_id))
  end

  def is_lead(user)
    user.id == lead_id
  end

  def lead
    User.where(:id=>lead_id)
  end

  def is_member(user)
    self.members.where(user:user).present?
  end

  def skill_update(user)
    user.user_skills.each do |us|
      if self.team_skills.where(skill:us.skill).present?
        l = self.team_skills.where(skill:us.skill).first.level
        c = self.team_skills.where(skill:us.skill).first.count
        level = [l,us.level].max
        count = c+1
        self.team_skills.where(skill:us.skill).first.update_attributes(level:level,count:count)
      else
        self.team_skills.create(level:us.level,skill:us.skill,count:1)
      end
    end
  end

  def skill_add(user)
    user.user_skills.each do |us|
      if self.team_skills.where(skill:us.skill).present?
        l = self.team_skills.where(skill:us.skill).first.level
        c = self.team_skills.where(skill:us.skill).first.count
        level = [l,us.level].max
        count = c+1
        self.team_skills.where(skill:us.skill).first.update_attributes(level:level,count:count)
      else
        self.team_skills.create(level:us.level,skill:us.skill,count:1)
      end
    end
  end

  def skill_update(user)
    user.user_skills.each do |us|
      m = self.members.where(user_id:UserSkill.where(skill:us.skill).select(:user_id))
      l = m.collect{|m|m.user.user_skills.where(skill:us.skill).first.level} - [us.level]
      c = self.team_skills.where(skill:us.skill).first.count - 1
      c==0 ? self.team_skills.where(skill:us.skill).first.destroy : self.team_skills.where(skill:us.skill).first.update_attributes(level:[l].max.max,count:c)
    end
  end

  def self.skill_match(user)
    skills = user.skills
    nteams = Team.where.not(id:TeamSkill.where(skill:skills).select(:team_id))
    yteams = Team.where(id:TeamSkill.where(skill:skills).select(:team_id))
    nteams | yteams
  end

end
