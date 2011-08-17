module ActsAsRelatable


  module Relatable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def acts_as_relatable(*relatable_models)
        # Create polymorphic associations
        class_attribute :relatable_types

        self.relatable_types = relatable_models.to_a.flatten.compact.map(&:to_sym) << self.to_s.underscore.to_sym

        has_many :relationships, :as => :relator, :order => "created_at desc", :class_name => "ActsAsRelatable::Relationship", :dependent => :destroy
        has_many :incoming_relationships, :as => :related, :class_name => "ActsAsRelatable::Relationship", :dependent => :destroy

        relatable_types.each do |rel|

          has_many "related_#{rel.to_s.pluralize}",
                                    :through => :relationships,
                                    :source => "related_#{rel.to_s}",
                                    :class_name => rel.to_s.classify,
                                    :conditions => { 'relationships.related_type' => rel.to_s.classify }

          has_many "relator_#{rel.to_s.pluralize}",
                                  :through => :incoming_relationships,
                                  :source => "relator_#{rel.to_s}",
                                  :class_name => rel.to_s.classify,
                                  :conditions => {'relationships.relator_type' => rel.to_s.classify}

          ActsAsRelatable::Relationship.belongs_to "relator_#{rel.to_s}".to_sym, :class_name => rel.to_s.classify, :foreign_key => :relator_id
          ActsAsRelatable::Relationship.belongs_to "related_#{rel.to_s}".to_sym, :class_name => rel.to_s.classify, :foreign_key => :related_id


        end

        include ActsAsRelatable::Relatable::InstanceMethods
        extend ActsAsRelatable::Relatable::SingletonMethods
      end
    end

    module SingletonMethods; end

    module InstanceMethods

      # This method creates relation between 2 objects.
      # Returns the relationships in an array or false if the relation already exists.
      # By default a bothsided relationship is created but this can be overiden by seting bothsided to false.
      #
      # Example :
      #   user = User.find 1
      #   place = Place.find 1
      #   user.relate_to! place
      def relates_to!(some_object, bothsided=true)
        return false if (self.related_to?(some_object) || self.eql?(some_object))

        ActsAsRelatable::Relationship.unscoped.create(:related => some_object, :relator => self)
        ActsAsRelatable::Relationship.unscoped.create(:related => self, :relator => some_object) if bothsided == true
      end

      # This method returns true if self is already related with some_object
      def related_to? some_object
        !!relation(some_object)
      end

      # This method returns the relationship between self and another_object, or nil
      def relation some_object
        ActsAsRelatable::Relationship.unscoped.where(:relator_id => self.id,
                                    :related_id => some_object.id,
                                    :relator_type => self.class.base_class.to_s,
                                    :related_type => some_object.class.base_class.to_s).first
      end

      # This method returns relatable objects from a given Array of models
      # Exemple : @category.relateds(:classes => ['Place', 'Event']) will return
      # {"Place" => [related_place1, related_place2], "Event" => [related_event1, related_event2]}
      def relateds(options = {})
         relateds = {}
         classes = options.try(:[], :classes) ? options[:classes] : relatable_types
         classes.each do |c|
           pluralized_rel = c.to_s.underscore.pluralize
           relations = self.send("related_#{pluralized_rel}").limit(options[:limit] || 10)
           relateds = relateds.merge(pluralized_rel.to_sym => relations) if relations.any?
         end
         relateds
      end

      # This method destroy the relationship between self (as a relator object) and some_object (as a related object).
      def destroy_relation_with some_object
        relationships_to_destroy = [relation(some_object), some_object.relation(self)]
        relationships_to_destroy.each { |r| r.destroy if r }
        relationships.reload
      end

    end

  end
end