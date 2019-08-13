class Collection < ApplicationRecord
  has_many :graphs, dependent: :destroy
end
