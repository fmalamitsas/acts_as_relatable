require "active_record"
require "active_record/version"

module ActsAsRelatable
  RelatableModels = ['Product', 'Shop', 'Tag'] #temp
end

require "acts_as_relatable/relatable"
require "acts_as_relatable/relationship"

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, ActsAsRelatable::Relatable
end
