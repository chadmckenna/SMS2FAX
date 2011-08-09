class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :SmsSid
      t.string :AccountSid
      t.string :From
      t.string :To
      t.string :Body
      t.string :FromCity
      t.string :FromState
      t.string :FromZip
      t.string :FromCountry
      t.string :ToCity
      t.string :ToState
      t.string :ToZip
      t.string :ToCountry

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
