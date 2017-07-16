class Program < ApplicationRecord

  validates_uniqueness_of :name
  validates_presence_of :name

  scope :asc, -> {order(name:'ASC')}
  scope :dsc, -> {order(name:'DESC')}

  scope :oneyr, -> {where("name iLIKE ?","%1%")}
  scope :twoyr, -> {where("name iLIKE ?","%2%")}
  scope :mba, -> {where("name iLIKE ?","%mba%")}

  def tag
    "#{name}, #{description}"
  end

  def students
    User.students.where(program:name)
  end

end
