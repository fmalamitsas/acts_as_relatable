class Product < ActiveRecord::Base
  acts_as_relatable :shop, :tag
end

class Tag < ActiveRecord::Base
  acts_as_relatable :product, :shop
end

class Shop < ActiveRecord::Base
  acts_as_relatable :tag, :product
end
