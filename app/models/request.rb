class Request < ApplicationRecord
  belongs_to :user
  validates :detail, presence: true, length: { maximum: 255 }
end
