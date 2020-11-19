class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.boolean :finish
      t.date :date
      t.integer :position
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
