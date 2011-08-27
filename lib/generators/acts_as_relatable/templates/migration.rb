class ActsAsRelatableMigration < ActiveRecord::Migration
  def self.up
    # Relationship table
    create_table :relationships do |t|
      t.integer  :relator_id
      t.string   :relator_type
      t.integer  :related_id
      t.string   :related_type
      t.string   :strength
      t.timestamps
    end

    # Relationship indexes
    add_index :relationships, :related_id
    add_index :relationships, :related_type
    add_index :relationships, :relator_id
    add_index :relationships, :relator_type
    add_index :relationships, :strength
  end


  def self.down
    drop_table :relationships
  end
end
