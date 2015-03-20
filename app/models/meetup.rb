class Meetup < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :location, presence: true


  has_many :comments, inverse_of: :meetup

  has_many :user_meetups
  has_many :users, through: :user_meetups
end
