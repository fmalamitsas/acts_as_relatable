module ActsAsRelatable
  class Relationship < ::ActiveRecord::Base
    belongs_to :relator, :polymorphic => true, :foreign_key => :relator_id, :touch => true
    belongs_to :related, :polymorphic => true, :foreign_key => :related_id, :touch => true

    ActsAsRelatable::Relatable::RelatableModels.each do |r|
      self.class_eval do
        belongs_to "relator_#{r.underscore}".to_sym, :class_name => r.to_s, :foreign_key => :relator_id
        belongs_to "related_#{r.underscore}".to_sym, :class_name => r.to_s, :foreign_key => :related_id
      end
    end

    validates :relator_id, :presence => true, :uniqueness => {:scope => [:relator_type, :related_id, :related_type]}
    validates :relator_type, :presence => true
    validates :related_id, :presence => true
    validates :related_type, :presence => true

  end
end