module Pagination
  extend self
  
  class Sequel::Model
    def self.page(page, per_page=COMMENTS_PER_PAGE || 10, *args)
      page = (page || 1).to_i
      dataset.paginate(page, per_page, *args)
    end
  end
   
  class Sequel::Dataset
    def page(page, per_page=COMMENTS_PER_PAGE || 10, *args)
      page = (page || 1).to_i
      paginate(page, per_page, *args)
    end
  end

end