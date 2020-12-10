class Group < ApplicationRecord
  belongs_to :user
  has_many :lists, ->{ order(position: :asc) }, dependent: :destroy
  has_many :invitations
end
