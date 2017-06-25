class Team < ApplicationRecord

  attr_accessor :comp_teams_attributes, :members_attributes
  validates :name, presence: true

  has_many :members, dependent: :destroy
  has_many :users, through: :members
  # accepts_nested_attributes_for :members, reject_if: proc { |attributes| attributes[:user_id].blank? }, allow_destroy: true

  has_many :comp_teams, dependent: :destroy
  has_many :competitions, through: :comp_teams
  accepts_nested_attributes_for :comp_teams, allow_destroy: true, reject_if: proc { |attributes| attributes[:competition_id].blank? }

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

end
