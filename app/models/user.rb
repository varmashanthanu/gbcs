class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  attr_accessor :address_attributes

  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: proc { |attributes| attributes[:addr].blank? }, allow_destroy: true

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  has_many :members, dependent: :destroy
  has_many :teams, through: :members

  mount_uploader :avatar, AvatarUploader

  # Name Calls
  def name
    (fname && fname!='' || lname && lname!='')? (fname||lname):email.split('@')[0].humanize
  end

  def fullname
    (fname && fname!='' || lname && lname!='')? "#{fname} #{lname}":name
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
end

