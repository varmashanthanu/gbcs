class Competition < ApplicationRecord

  # attr_accessor :name, :description
  #
  # belongs_to :creator, :class_name => :user, foreign_key: :user_id

  validates :name, presence: true

  has_many :comp_teams, dependent: :destroy
  has_many :teams, through: :comp_teams

  private

  def participant(user)
    self.teams.exists?Team.where(:id => Member.where(user:user).select(:team_id))
  end

end
