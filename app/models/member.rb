class Member < ApplicationRecord
  belongs_to :user
  belongs_to :team

  after_commit :update_dependants, on: [:create, :update]
  after_create :notify

  def transfer(o,n)
    if self.update_attributes(team:n)
      o.skill_update
      n.skill_update
      true
    else
      false
    end
  end

  def notify
    Notification.create(user:self.team.lead.first,recipient:self.user,notifiable:self.team,action:'added')
  end

  def update_dependants
    self.team.skill_update
  end

end
