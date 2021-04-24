class Comment < ApplicationRecord
  belongs_to :article
  validates :article_id, presence: true
  validates :description, presence: true, length: { maximum: 1000 }
end
