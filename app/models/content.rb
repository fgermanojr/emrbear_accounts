class Content < ApplicatonRecord
  belongs_to :relationship
  validates :content_text, presence: true
end