class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :level, presence: true
  # validates :skill_id, uniqueness: true
  after_commit :update_dependants, on: [:create, :update]

  def duplicate(user)
    UserSkill.where("skill_id = ? AND user_id = ?", self.skill_id, user.id).present?
  end

  def name
    self.skill.name
  end

  def update_dependants
    self.user.calc_score
  end

  # TODO rethink the scoring mechanism
  def weighted_level

    (self.level*self.skill.rank)*1.00 #need to find optimized way to evaluate multiplier
  end

end
