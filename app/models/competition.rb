class Competition < ApplicationRecord

  # attr_accessor :name, :description
  #
  # belongs_to :creator, :class_name => :user, foreign_key: :user_id

  validates :name, presence: true

  has_many :comp_teams, dependent: :destroy
  has_many :teams, through: :comp_teams

  belongs_to :creator, class_name: 'User'

  scope :latest, -> {order(created_at:'DESC')}

  def participant(user)
    self.teams.exists?Team.where(:id => Member.where(user:user).select(:team_id))
  end

  def participants
    self.teams.collect{|t|t.users}.flatten
  end

  def self.mine(user)
    where(:id => CompTeam.where(:team_id => user.teams.pluck(:id)).pluck(:competition_id))
  end

  def user_team(user)
    user.teams.where(:id => self.comp_teams.pluck(:team_id) ).first
  end

  def full_url
    if url.include?'http'
      url
    else
      'http://'+url
    end
  end

end
