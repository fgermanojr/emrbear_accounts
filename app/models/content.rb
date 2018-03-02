class Content < ApplicationRecord
  belongs_to :relationship
  validates :content_text, presence: true
  validates :account_id, presence: true
  validates :user_id, presence: true
end