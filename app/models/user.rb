class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

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
  # validates_format_of :email, with: /\@ufl\.edu/, message: 'should have ufl.edu domain.'

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
  # TODO better way to create the scoring
  def skill_score
    score = 0
    self.user_skills.each do |s|
      score += s.weighted_level
    end
    score/Skill.count*100
  end

  # TODO Do I really this function here? Shall I just call members on the Team Model?
  def self.team_members(team)
    where(:id=>Member.where(team:team).select(:user_id))
  end

  # def self.students
  #   where('admin IS NULL OR admin is FALSE')
  # end
  # def self.faculty
  #   where(admin: true)
  # end
end

