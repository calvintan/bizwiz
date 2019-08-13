class AddReferencesToGraphs < ActiveRecord::Migration[5.2]
  def change
    add_reference :graphs, :collection, foreign_key: true
  end
end
