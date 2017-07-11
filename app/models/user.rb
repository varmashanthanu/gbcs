class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :confirmable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  after_initialize :init, :init_pref_addr

  attr_accessor :address_attributes, :teams_attributes

  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: proc { |attributes| attributes[:addr].blank? }, allow_destroy: true

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  has_many :members, dependent: :destroy
  has_many :teams, through: :members

  has_many :yes_lists, dependent: :destroy

  has_one :preference, dependent: :destroy

  scope :faculty, -> {where(admin: true)}
  scope :students, -> {where('admin IS NULL OR admin is FALSE')}

  mount_uploader :avatar, AvatarUploader

  # Email validator for UFL domains. Uncomment when ready to launch.
  validates_format_of :email, with: /\@ufl\.edu/, message: 'should have ufl.edu domain.'

  # Initializer
  def init_pref_addr
    self.preference = Preference.new(location:'Any',competition:'Any') unless self.preference.present?
    self.build_address unless self.preference.present?
  end

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
        data[category] += us.weighted_level/50.0
      end
    end
    data
  end

  def indi_skill_calc
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
    yes_students = User.students.where.not(id:YesList.where(user:user, match:'NO').select(:target_id)).order(score:'DESC')
    # yes_students = User.where(id:YesList.where("user = ? AND match = ? OR match IS NULL", user,'YES').select(:target_id))
    same_year = yes_students.where(graduation:user.graduation).order(score:'DESC')
    # mix_year_yes_students = yes_students.where(graduation:nil)# change this after seeding
    mix_year_yes_students = yes_students.where.not(graduation:user.graduation).order(score:'DESC')# change this after seeding
    same_class = mix_year_yes_students.where(program:user.program).order(score:'DESC')
    mix_class_year_yes_students = mix_year_yes_students.where.not(program:user.program).order(score:'DESC')

    mix_class_year_yes_students.order(score:'DESC')
    same_class.order(score:'DESC')
    same_year.order(score:'DESC')
    hate_list.order(score:'DESC')

    mix_class_year_yes_students | same_class | same_year | hate_list
  end

  def self.search(priority,order)
    users = User.students

    string = []
    query = ''
    string << priority[:sp1].downcase+' '+order[:so1] if priority[:sp1].present?
    string << priority[:sp2].downcase+' '+order[:so2] if priority[:sp2].present?
    string << priority[:sp3].downcase+' '+order[:so3] if priority[:sp3].present?

    string.each do |s|
      query += s
      query += ', ' unless s==string.last
    end


    users.order(query)
  end

  # TODO Do I really this function here? Shall I just call members on the Team Model?
  def self.team_members(team)
    where(:id=>Member.where(team:team).select(:user_id))
  end


end

