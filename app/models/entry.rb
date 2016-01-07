class Entry < ActiveRecord::Base
  validates :userid, presence: true, uniqueness: true
  validates :sex, presence: true

  belongs_to :guset, foreign_key: :userid
end
