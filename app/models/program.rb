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
    User.students.where(program:self.name)
  end

  def self.distribution
    data = {}
    self.all.each do |program|
      data[program.name] = User.where(program:program.name).count
    end
    data
  end

  def distribution
    data = {}
    self.students.each do |student|
      data[student.term] ? data[student.term] +=1 : data[student.term]=1
    end
    data.sort_by{|k,v|k}
  end

end
