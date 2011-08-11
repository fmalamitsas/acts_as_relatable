ActiveRecord::Schema.define :version => 0 do
  create_table :products, :force => true do |t|
    t.string :name
    t.integer :price
  end

  create_table :tags, :force => true do |t|
    t.string :name
  end

  create_table :shops, :force => true do |t|
    t.string :name
    t.integer :size
  end

  create_table :relationships, :force => true do |t|
    t.integer  :relator_id
    t.string   :relator_type
    t.integer  :related_id
    t.string   :related_type
    t.timestamps
  end
end