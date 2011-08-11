class Product < ActiveRecord::Base
  acts_as_relatable
end

class Tag < ActiveRecord::Base
  acts_as_relatable
end

class Shop < ActiveRecord::Base
  acts_as_relatable
end
