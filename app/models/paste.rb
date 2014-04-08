class Paste < ActiveRecord::Base
  attr_accessor :truncated

  validates :body, presence: true, length: { maximum: 250000 }
  validate :title, length: { maximum: 500 }

  paginates_per 10
end
