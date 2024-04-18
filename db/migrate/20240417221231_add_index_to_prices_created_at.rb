class AddIndexToPricesCreatedAt < ActiveRecord::Migration[7.1]
  def change
    add_index :prices, :created_at
  end
end
