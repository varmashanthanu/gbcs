class Competition < ApplicationRecord

  # attr_accessor :name, :description
  #
  # belongs_to :creator, :class_name => :user, foreign_key: :user_id

  validates :name, presence: true

end
