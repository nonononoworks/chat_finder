class Guest < ActiveRecord::Base
  validates :userid, presence: true, uniqueness: true
  validates :sex, presence: true

  has_one :entry, dependent: :destroy, foreign_key: :userid
end
