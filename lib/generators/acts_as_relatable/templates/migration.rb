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
    add_index :relationships, [:relator_id, :relator_type, :related_type]
  end


  def self.down
    drop_table :relationships
  end
end
