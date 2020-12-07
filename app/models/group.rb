class Group < ApplicationRecord
  belongs_to :user
  has_many :lists, ->{ order(position: :asc) }, dependent: :destroy
end
