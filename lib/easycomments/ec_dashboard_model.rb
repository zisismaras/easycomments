require_relative "../easycomments.rb"

module ECDashboardModel
  extend self
  include Pagination
  
  def get_comments(post, page_num)
    comments = DB[:comments].where(:post => post).reverse(Sequel.asc(:timestamp)).page(page_num).all
    count =  DB[:comments].where(:post => post).page(page_num).page_count
    comments = comments.each{|comment| comment[:timestamp] = comment[:timestamp].strftime(TIMESTAMP_FORMAT)}
    MultiJson.dump(:comments => comments, :page_count => count)
  end

  def get_all_posts
   MultiJson.dump({:posts => DB[:comments].map(:post).uniq})
  end

  def edit_comment(id, new_body)
    DB[:comments].where(:id => id).update(:body => new_body, :action_taken => true)
    MultiJson.dump({:status => "Comment successfully edited."})
  end

  def remove_comment(id)
    DB[:comments].where(:id => id).delete
    MultiJson.dump({:status => "Comment successfully removed."})
  end

  def comment_change_approval(id)
    comment = DB[:comments].where(:id => id).all.first
    DB[:comments].where(:id => id).update(:approved => !comment[:approved], :action_taken => true)
    MultiJson.dump({:status => "Approval status successfully changed."})
  end

  def get_total_pending
    pending = DB[:comments].where(:action_taken => false).all.count
    MultiJson.dump({:pending => pending})
  end

  def get_posts_with_pending
    pending =[]
    posts = DB[:comments].where(:action_taken => false).map(:post).uniq
    posts.each do |post|
      pending.push({:post  => post, :pending => DB[:comments].where(:post => post, :action_taken => false).count})
    end
    MultiJson.dump({:pending => pending})
  end

  def get_pending_comments(post, page_num)
    comments = DB[:comments].where(:post => post, :action_taken => false).reverse(Sequel.asc(:timestamp)).page(page_num).all
    count =  DB[:comments].where(:post => post, :action_taken => false).page(page_num).page_count
    comments = comments.each{|comment| comment[:timestamp] = comment[:timestamp].strftime(TIMESTAMP_FORMAT)}
    MultiJson.dump({:comments => comments, :page_count => count})
  end

  def ignore_comment(id)
    comment = DB[:comments].where(:id => id).all.first
    DB[:comments].where(:id => id).update(:action_taken => true)
    MultiJson.dump({:status => "Comment successfully ignored."})
  end

  def authenticate(username, password)
    access = {}
    CONFIG[:users].each_pair do |u, p|
      if username == u && BCrypt::Password.new(p) == password
        access = {:has_access => true}
      else
        access = {:has_access => false}
      end
    end
    MultiJson.dump(access)
  end

end