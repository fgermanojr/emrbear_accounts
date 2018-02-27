class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :contents
  validates :type, presence: true
end