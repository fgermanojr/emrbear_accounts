class Account < ApplicationRecord
  has_many :relationships
  has_many :users, through: :relationships
  validates :name, presence: true, uniqueness: true
end