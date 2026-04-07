class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.boolean :free, default: true, null: false
      t.boolean :advance, default: false, null: false
      t.boolean :pro, default: false, null: false
      t.boolean :admin, default: false, null: false

      t.timestamps
    end
  end
end
