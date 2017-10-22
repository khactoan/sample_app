class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    add_column :users, :password_digest, :string
    add_column :users, :remember_digest, :string
    add_index :users, :email, unique: true
    add_column :users, :is_admin, :boolean, default: false
  end
end
