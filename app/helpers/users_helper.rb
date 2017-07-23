module UsersHelper

  def user_skills
    current_user.user_skills
  end
  def user_teams
    current_user.members.limit(5)
  end
  def invites
    Invite.received(current_user)
  end
  def comps
    Competition.mine(current_user)
  end
  def new_comps
    Competition.latest.limit(5)
  end
end
