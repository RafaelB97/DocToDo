class Task < ApplicationRecord
  acts_as_list scope: :list

  belongs_to :list
end
