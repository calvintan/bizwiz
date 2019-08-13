class Graph < ApplicationRecord
  has_many :datatables, dependent: :destroy
  belongs_to :collection
end
