module ActsAsRelatable
  module Relatable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_relatable(*args)
        # Create polymorphic associations
        relatable_class_names = ActsAsRelatable::Relationship.relatables.to_a.flatten.compact.map{ |m| m.to_s }

        has_many :relationships, :as => :relator, :order => "created_at desc", :class_name => "ActsAsRelatable::Relationship", :dependent => :destroy
        has_many :incoming_relationships, :as => :related, :class_name => "ActsAsRelatable::Relationship", :dependent => :destroy


        relatable_class_names.each do |rel|

          has_many "related_#{rel.tableize}",
                                    :through => :relationships,
                                    :source => "related_#{rel.underscore}",
                                    :class_name => rel,
                                    :conditions => { 'relationships.related_type' => rel }

          has_many "relator_#{rel.tableize}",
                                  :through => :incoming_relationships,
                                  :source => "relator_#{rel.underscore}",
                                  :class_name => rel,
                                  :conditions => {'relationships.relator_type' => rel}
         end

        include ActsAsRelatable::Relatable::InstanceMethods
        extend ActsAsRelatable::Relatable::SingletonMethods
      end
    end

    module SingletonMethods
    end

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

        Relationship.unscoped.create(:related => some_object, :relator => self)
        Relationship.unscoped.create(:related => self, :relator => some_object) if bothsided == true
      end

      # This method returns true if self is already related with some_object
      def related_to? some_object
        !!relation(some_object)
      end

      # This method returns the relationship between self and another_object, or nil
      def relation some_object
        Relationship.unscoped.where(:relator_id => self.id, :related_id => some_object.id, :relator_type => self.class.base_class.to_s, :related_type => some_object.class.base_class.to_s).first
      end

      # This method returns relatable objects from a given Array of models
      # Exemple : @category.relateds(:classes => ['Place', 'Event']) will return
      # {"Place" => [related_place1, related_place2], "Event" => [related_event1, related_event2]}
      def relateds(options = {})
         relateds = {}
         if options.try(:[], :classes)
           classes = options[:classes].is_a?(String) ? [options[:classes]] : options[:classes]
         else
           classes = Relationship.relatables
         end
         classes.each do |c|
           relations = self.send("related_#{c.underscore.pluralize}").limit(options[:limit] || 10)
           relateds = relateds.merge(c.underscore.pluralize.to_sym => relations) if relations.any?
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