module ActsAsRelatable
  class Relationship < ::ActiveRecord::Base
    belongs_to :relator, :polymorphic => true, :foreign_key => :relator_id, :touch => true
    belongs_to :related, :polymorphic => true, :foreign_key => :related_id, :touch => true

    validates :relator_id, :presence => true, :uniqueness => {:scope => [:relator_type, :related_id, :related_type]}
    validates :relator_type, :presence => true
    validates :related_id, :presence => true
    validates :related_type, :presence => true
    validate :self_relation

    # This method relates two object together
     def self.make_between(relator, related, bothsided=true)
       relator.relates_to!(related, bothsided)
     end

     protected

     # It's impossible to create a relation with self as related object.
     def self_relation
       errors.add(:base, "could not create a relation that links to the same element!") if related == relator
     end
  end
end