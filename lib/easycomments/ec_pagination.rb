module Pagination
  extend self
  
  class Sequel::Model
    def self.page(page, per_page=COMMENTS_PER_PAGE || 10, *args)
      page = page.to_i
      page = 1 if page < 1
      dataset.paginate(page, per_page, *args)
    end
  end
   
  class Sequel::Dataset
    def page(page, per_page=COMMENTS_PER_PAGE || 10, *args)
      page = page.to_i
      page = 1 if page < 1
      paginate(page, per_page, *args)
    end
  end

end