class UserMeetup < ActiveRecord::Base
  validates :user, uniqueness: { scope: :meetup }


  belongs_to :user
  validates :user, presence: true

  belongs_to :meetup
  validates :meetup, presence: true
end
