class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  after_initialize :init

  attr_accessor :address_attributes, :teams_attributes

  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: proc { |attributes| attributes[:addr].blank? }, allow_destroy: true

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  has_many :members, dependent: :destroy
  has_many :teams, through: :members

  has_many :yes_lists, dependent: :destroy

  scope :faculty, -> {where(admin: true)}
  scope :students, -> {where('admin IS NULL OR admin is FALSE')}

  mount_uploader :avatar, AvatarUploader

  # Email validator for UFL domains. Uncomment when ready to launch.
  validates_format_of :email, with: /\@ufl\.edu/, message: 'should have ufl.edu domain.'

  # Name Calls
  def name
    (fname && fname!='' || lname && lname!='')? (fname||lname):email.split('@')[0].humanize
  end

  def fullname
    (fname && fname!='' || lname && lname!='')? "#{fname} #{lname}":name
  end
  def tag
    "#{lname}, #{fname}"
  end

  def update_password_error(user_params)
    if user_params[:password].length < 6
      'Password is too short'
    elsif user_params[:password] != user_params[:password_confirmation]
      'Confirmation Password does not match.'
    elsif !self.valid_password?(user_params[:current_password])
      'Please enter your current Password.'
    else
      'Update Failed, Please try again.'
    end
  end

  # Calculating the User Score
  def calc_score
    score = 0.0
    Skill.all.each do |s|
      score += self.user_skills.where(skill:s).any? ? self.user_skills.where(skill:s).first.weighted_level : 0
    end
    (score/Skill.count).ceil
  end

  # Skill_Calc builds a data hash for Skill category & Score for building a graph.
  def skill_calc
    data = Skill.group(:category).count
    data.each do |category,score|
      data[category] = 0
      userskill = self.user_skills.where(:skill => Skill.where(category:category))
      userskill.each do |us|
        data[category] += us.weighted_level
      end
    end
    data
  end

  def indi_skill_calc
    # data = Skill.group(:category).count
    # data.each do |category,set|
    #   skill_weight = Skill.where(category:category).group(:name).count
    #   skill_weight.each do |name,score|
    #     skill_weight[name] = self.user_skills.where(:skill => Skill.where(name:name)).any? ? self.user_skills.where(:skill => Skill.where(name:name)).first.level : 0
    #   end
    #   data[category] = skill_weight
    # end
    # data
    skill_weight = Skill.group(:name).count
    skill_weight.each do |name,score|
      skill_weight[name] = self.user_skills.where(:skill => Skill.where(name:name)).any? ? self.user_skills.where(:skill => Skill.where(name:name)).first.level : 0
    end
    skill_weight
  end

  def init
    self.score ||= 0
  end

  def self.gen_sort(user)
    # hate_list = User.where(id:YesList.where("user_id = ? AND match = ?", user, "NO").select(:target_id))
    hate_list = User.students.where(id:YesList.where(user:user, match:'NO').select(:target_id)).order(score:'DESC')
    Rails.logger.debug(hate_list.count)
    Rails.logger.debug(' TEST 1 ')
    yes_students = User.students.where.not(id:YesList.where(user:user, match:'NO').select(:target_id)).order(score:'DESC')
    # yes_students = User.where(id:YesList.where("user = ? AND match = ? OR match IS NULL", user,'YES').select(:target_id))
    Rails.logger.debug(yes_students.class)
    Rails.logger.debug(' TEST 2')
    same_year = yes_students.where(graduation:user.graduation).order(score:'DESC')
    Rails.logger.debug(same_year.count)
    Rails.logger.debug(' TEST 3')
    # mix_year_yes_students = yes_students.where(graduation:nil)# change this after seeding
    mix_year_yes_students = yes_students.where("graduation != ? OR graduation is NULL", user.graduation).order(score:'DESC')# change this after seeding
    Rails.logger.debug(mix_year_yes_students.count)
    Rails.logger.debug(' TEST 4')
    same_class = mix_year_yes_students.where(program:user.program).order(score:'DESC')
    Rails.logger.debug(same_class.count)
    Rails.logger.debug(' TEST 5')
    mix_class_year_yes_students = mix_year_yes_students.where("program != ? OR program is NULL ",user.program).order(score:'DESC')
    Rails.logger.debug(mix_class_year_yes_students.count)
    Rails.logger.debug(' TEST 6')
    Rails.logger.debug(mix_class_year_yes_students.class)

    mix_class_year_yes_students.order(score:'DESC')
    same_class.order(score:'DESC')
    same_year.order(score:'DESC')
    hate_list.order(score:'DESC')

    students = User.none

    mix_class_year_yes_students.each do |d|
      students+=[d]
    end
    same_class.each do |d|
      students<<d
    end
    same_year.each do |d|
      students<<d
    end
    hate_list.each do |d|
      students<<d
    end

    # students = mix_class_year_yes_students.merge(same_class).merge(same_year).merge(hate_list)
    # Rails.logger.debug(students.count)
    # Rails.logger.debug(' TEST 7')
    #
    # Rails.logger.debug('TESTTTTTIIIINNNNGGGGGG')
    # Rails.logger.debug(students.class)
    return students
  end

  # TODO Do I really this function here? Shall I just call members on the Team Model?
  def self.team_members(team)
    where(:id=>Member.where(team:team).select(:user_id))
  end


end

