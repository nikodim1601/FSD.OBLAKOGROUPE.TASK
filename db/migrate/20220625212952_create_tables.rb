class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
    end

    create_table :todos do |t|
      t.string :text
      t.boolean :isCompleted
      t.belongs_to :project
    end
  end
end
