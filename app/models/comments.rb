class Comment < ActiveRecord::Base
  validates :description, presence: true, length: { maximum: 140 }

  belongs_to :user
  validates :user, presence: true

  belongs_to :meetup
  validates :meetup, presence: true
end
