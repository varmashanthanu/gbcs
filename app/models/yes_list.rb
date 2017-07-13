class YesList < ApplicationRecord
  belongs_to :user, :class_name => 'User'
  belongs_to :target, :class_name => 'User'


  def self.duplicate(ylist)
    where("user_id = ? AND target_id = ?", ylist.user.id, ylist.target.id) || false
  end

  def self.compatibility(members)
    data = Hash.new
    members.each do |m|
      data[m.name] = m.yes_lists.where(target:members,match:'NO') if m.yes_lists.where(target:members,match:'NO').present?
    end
    data
  end
  # def toggle
  #    unless !self.match
  #      self.match == 'YES' ? self.match = 'NO' : self.match = 'YES'
  #    end
  # end

end
