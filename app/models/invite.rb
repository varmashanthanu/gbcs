class Invite < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :sender, class_name: 'User'

  scope :sent, -> {where(sender_id:current_user.id)}
  scope :received, -> {where(user:current_user)}

  def self.received(user)
    where(user:user)
  end

  def self.sent(user)
    where(sender_id:user)
  end

  def self.duplicate(invite)
    where("user_id = ? AND team_id = ?", invite.user_id, invite.team_id) || false
  end
end
