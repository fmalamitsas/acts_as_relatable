class ActsAsRelatableMigration < ActiveRecord::Migration
  def self.up
    # Relationship table
    create_table :relationships do |t|
      t.integer  :relator_id
      t.string   :relator_type
      t.integer  :related_id
      t.string   :related_type
      t.timestamps
    end

    # Relationship indexes
    add_index :relationships, ["related_id"], :name => "index_relationships_on_related_id"
    add_index :relationships, ["related_type", "related_id"], :name => "poly_relationships_related"
    add_index :relationships, ["relator_id"], :name => "index_relationships_on_relator_id"
    add_index :relationships, ["relator_type", "relator_id"], :name => "poly_relationships_relator"
  end


  def self.down
    drop_table :relationships

    remove_index :relationships, :name => "index_relationships_on_related_id"
    remove_index :relationships, :name => "poly_relationships_related"
    remove_index :relationships, :name => "index_relationships_on_relator_id"
    remove_index :relationships, :name => "poly_relationships_relator"
  end
end
