require "active_record"
require "active_record/version"
require "action_view"

require "acts_as_relatable/relatable"
require "acts_as_relatable/relationship"

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, ActsAsRelatable::Relatable
end
