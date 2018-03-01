class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :contents
  validates :relationship_type, presence: true
  scope :is_owner, -> { where(relationship_type: 'owner') }
  scope :is_member, -> { where(relationship_type: 'member') }
end