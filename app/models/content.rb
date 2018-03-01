class Content < ApplicationRecord
  belongs_to :relationship
  validates :content_text, presence: true
end