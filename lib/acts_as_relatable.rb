require "active_record"
require "active_record/version"

require "acts_as_relatable/relationship"
require "acts_as_relatable/relatable"

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, ActsAsRelatable::Relatable
end

require 'rails/generators'