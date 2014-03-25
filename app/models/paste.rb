class Paste < ActiveRecord::Base
  validates :body, presence: true
end
