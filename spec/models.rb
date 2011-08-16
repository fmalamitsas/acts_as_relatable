class Product < ActiveRecord::Base
  acts_as_relatable :shop, :tag, :product
end

class Tag < ActiveRecord::Base
  acts_as_relatable :product, :shop, :tag
end

class Shop < ActiveRecord::Base
  acts_as_relatable :tag, :product, :shop
end
