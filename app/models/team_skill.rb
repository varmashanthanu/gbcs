class TeamSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :team, counter_cache: true

  after_initialize :init

  def init
    self.count ||= 0
  end

  def name
    self.skill.name
  end
  # TODO rethink the scoring mechanism
  def weighted_level

    (self.skill.rank*Skill.mult * self.level).floor #need to find optimized way to evaluate multiplier
  end

end
