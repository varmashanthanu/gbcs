class Address < ApplicationRecord

  belongs_to :addressable, :polymorphic => true, optional: true

  geocoded_by :addr
  after_validation :geocode, :if => :addr.present? and :addr_changed?

end
