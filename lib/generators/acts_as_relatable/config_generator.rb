module ActsAsRelatable
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_ability
        copy_file "acts_as_relatable.rb", "config/initializers/acts_as_relatable.rb"
      end
    end
  end
end
