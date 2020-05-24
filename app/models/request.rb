class Request < ApplicationRecord
  belongs_to :user
  validates :detail, presence: true
end
