class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :level, presence: true
  # validates :skill_id, uniqueness: true

  def duplicate(user)
    if UserSkill.where("skill_id = ? AND user_id = ?", self.skill_id, user.id).present?
      true
      Rails.logger.debug('Triggered duplicate')
    else
      false
    end
  end

  def name
    self.skill.name
  end
  # TODO rethink the scoring mechanism
  def weighted_level
    self.skill.rank * level
  end

end
