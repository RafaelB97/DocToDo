class List < ApplicationRecord
  acts_as_list scope: :group
  belongs_to :group
  has_many :tasks, ->{ order(position: :asc) }, dependent: :destroy

  scope :sorted, -> { order(position: :asc) }
end
