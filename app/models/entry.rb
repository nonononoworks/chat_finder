class Entry < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :sex, presence: true
end
