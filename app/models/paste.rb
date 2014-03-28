class Paste < ActiveRecord::Base
  attr_accessor :truncated

  validates :body, presence: true

  paginates_per 10
end
