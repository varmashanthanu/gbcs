class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :confirmable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  after_initialize :init, :init_pref_addr

  before_destroy :cleanup

  attr_accessor :address_attributes, :teams_attributes, :invites_attributes

  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: proc { |attributes| attributes[:addr].blank? }, allow_destroy: true

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  has_many :members, dependent: :destroy
  has_many :teams, through: :members

  has_many :yes_lists, dependent: :destroy
  has_many :marked, through: :yes_lists, source: :target

  has_one :preference, dependent: :destroy

  has_many :competitions, foreign_key: :creator_id

  has_many :invites, foreign_key: :user_id, dependent: :destroy
  has_many :requests, :class_name => 'Invite', foreign_key: :sender_id, dependent: :destroy

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  scope :faculty, -> {where(admin: true)}
  scope :students, -> {where('admin IS NULL OR admin is FALSE')}
  scope :active, -> {where(active: true)}
  scope :inactive, -> {where('active IS NULL OR active is FALSE')}

  mount_uploader :avatar, AvatarUploader

  # Email validator for UFL domains. Uncomment when ready to launch.
  validates_format_of :email, with: /\@ufl\.edu/, message: 'should have ufl.edu domain.'

  # Initializer
  def init_pref_addr
    self.preference = Preference.new(location:'Any',competition:'Any') unless self.preference.present?
    self.build_address unless self.preference.present?
  end

  def cleanup
    Notification.where(sender:self).destroy_all
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
      'Incorrect Old Password.'
    else
      'Update Failed, Please try again.'
    end
  end

  # Calculating the User Score
  def calc_score
    skill_count = self.user_skills.where("level > ?", 0).count
    secondary = (5.00/Skill.count)
    multiplier = 95.00/(5*Skill.group(:category).count.count)
    score = 0.00
    self.user_skills.each do |us|
      score += us.weighted_level
    end
      self.score = score*multiplier.round(2) + skill_count*secondary.round(2)
  end

  def self.refresh
    User.students.each do |u|
      u.update_attributes(score:u.calc_score)
    end
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
    data = []
    Skill.group(:category).count.each do |cat|
      set = {}
      set[:name] = cat[0]
      set[:data] = []
      self.user_skills.where(skill:Skill.where(category:cat)).each do |skill|
        set[:data] << [skill.name,skill.level]
      end
      data << set
    end
    data
  end

  def init
    self.score ||= 0
    self.graduation ||= Date.today.year + 1
    self.term ||= 'Pending'
    self.program ||= 'Pending'
  end

  # def self.gen_sort(user)
  #   # hate_list = User.where(id:YesList.where("user_id = ? AND match = ?", user, "NO").select(:target_id))
  #   hate_list = User.students.where(id:YesList.where(user:user, match:'NO').select(:target_id)).order(score:'DESC')
  #   yes_students = User.students.where.not(id:YesList.where(user:user, match:'NO').select(:target_id)).order(score:'DESC')
  #   # yes_students = User.where(id:YesList.where("user = ? AND match = ? OR match IS NULL", user,'YES').select(:target_id))
  #   same_year = yes_students.where(graduation:user.graduation).order(score:'DESC')
  #   # mix_year_yes_students = yes_students.where(graduation:nil)# change this after seeding
  #   mix_year_yes_students = yes_students.where.not(graduation:user.graduation).order(score:'DESC')# change this after seeding
  #   same_class = mix_year_yes_students.where(program:user.program).order(score:'DESC')
  #   mix_class_year_yes_students = mix_year_yes_students.where.not(program:user.program).order(score:'DESC')
  #   # TODO "ORDER BY SCORE" may be redundant in this section. Need to Review
  #   mix_class_year_yes_students.order(score:'DESC')
  #   same_class.order(score:'DESC')
  #   same_year.order(score:'DESC')
  #   hate_list.order(score:'DESC')
  #
  #   mix_class_year_yes_students | same_class | same_year | hate_list
  # end

  def self.search(n)

    return students unless n.present?

    names = []
    n = n.split(/\W+/)
    n.each{|name|names<<"%#{name.downcase}%" unless name==''}
    query = ''
    names.each{|name| name == names.last ? query<<'fname iLIKE ? OR lname iLIKE ?' : query<<'fname iLIKE ? OR lname iLIKE ? OR ' }
    self.where(query,*names, *names)

  end

  def self.sorter(priority,order)
    return order(lname:'ASC') unless priority.present?

    string = []
    query = ''
    string << priority[:sp1].downcase+' '+order[:so1] if priority[:sp1].present?
    string << priority[:sp2].downcase+' '+order[:so2] if priority[:sp2].present?
    string << priority[:sp3].downcase+' '+order[:so3] if priority[:sp3].present?

    string.each do |s|
      query += s
      query += ', ' unless s==string.last
    end
    query.present? ? order(query) : order(lname:'ASC')
  end

  def self.filter(filter)
    return where(nil) unless filter.present?

    programs = []
    graduations = []
    terms = []
    users = where(nil)

    if filter[:programs].present?
      filter[:programs].each{|p|programs<<p unless p==''}
      query = ''
      programs.each{|program|program == programs.last ? query<<'program = ?' : query<<'program = ? OR '}
      users = users.where(query,*programs)
    end
    if filter[:graduations].present?
      filter[:graduations].each{|g|graduations<<g unless g==''}
      query = ''
      graduations.each{|graduation|graduation == graduations.last ? query<<'graduation = ?' : query<<'graduation = ? OR '}
      users = users.where(query,*graduations)
    end
    if filter[:terms].present?
      filter[:terms].each{|t|terms<<t unless t==''}
      query = ''
      terms.each{|term|term == terms.last ? query<<'term = ?' : query<<'term = ? OR '}
      users = users.where(query,*terms)
    end

    users
  end

  def self.hated
    list = YesList.where(match:'NO').select(:target_id).group(:target_id).limit(10).count.sort_by { |k,v|v}.reverse
    data = Hash.new
    list.each do |k,v|
      data[User.find(k).fullname] = v
    end

    data
  end
  def self.difficult
    list = YesList.where(match:'NO').select(:user_id).group(:user_id).limit(10).count.sort_by { |k,v|v}.reverse
    data = Hash.new
    list.each do |k,v|
      data[User.find(k).fullname] = v
    end

    data
  end

  # TODO Do I really this function here? Shall I just call members on the Team Model?
  def self.team_members(team)
    where(:id=>Member.where(team:team).select(:user_id))
  end

  def self.combined_skills(users)
    c_skills = Skill.group(:category).count
    c_skills.each do |k,v|
      c_skills[k] = 0
    end

    users.each do |u|
      temp = u.skill_calc
      temp.each do |k,v|
        c_skills[k] = [c_skills[k],temp[k]].max
      end
    end
    c_skills
  end

  def self.no_pref(user)
    yes_listed = user.yes_lists.collect{|y|y.target_id}
    User.where.not(id:yes_listed)
  end

  def likes(user)
    self.yes_lists.where(target:user,match:'YES').present? ? true : false
  end

  # def self.combined_skills(users)
  #   c_skills = Hash.new
  #   Skill.order(:category).all.each do |k,v|
  #     c_skills[k.name] = 0
  #   end
  #
  #   users.each do |u|
  #     u.user_skills.each do |us|
  #       c_skills[us.name] = [c_skills[us.name],us.level].max
  #     end
  #   end
  #   data = Hash.new
  #   c_skills.each do |k,v|
  #     data[k] = c_skills[k] if c_skills[k] > 0
  #   end
  #   data
  #   Rails.logger.debug(data)
  # end


end

