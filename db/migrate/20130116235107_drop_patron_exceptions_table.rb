class DropPatronExceptionsTable < ActiveRecord::Migration
  def up
    drop_table :patron_exceptions
  end

  def down
    create_table :patron_exceptions do |t|
       t.string :username
       t.string :role
       t.text :description

       t.timestamps
     end
  end
end
