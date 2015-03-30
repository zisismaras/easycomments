require_relative "../easycomments.rb"

module ECModel
  
  extend self

  def post_comment(comment)
    if comment[:body] != "undefined" && comment[:body] != ""
      if ALLOW_ANONYMOUS_POST
        comment[:name] = "Anonymous" if comment[:name] == "undefined" || comment[:name]  == ""
        comment[:email] = "no_email" if comment[:email] == "undefined" || comment[:email]  == ""
        save_comment(comment)
      elsif comment[:name] == "Anonymous" || comment[:name] == "undefined" || comment[:name]  == ""
        MultiJson.dump({:status => "Error : no name provided."})
      else
        save_comment(comment)
      end
    else
     MultiJson.dump({:status => "Error : no comment provided."})
    end
  end

  def get_comments(post)
    comments = DB[:comments].where(:post => post, :approved => true).all.sort_by{|comment| comment[:id].to_i}.reverse #show latest comment first
    comments = comments.each{|comment| comment[:timestamp] = comment[:timestamp].strftime(TIMESTAMP_FORMAT)}
    MultiJson.dump({:comments => comments})
  end

  private
  def escape_comment(comment)
    comment[:name] = Rack::Utils.escape_html(comment[:name])
    comment[:email] = Rack::Utils.escape_html(comment[:email])
    comment[:body] = Rack::Utils.escape_html(comment[:body])
    comment
  end

  def save_comment(comment)
    comment = escape_comment(comment)
    DB[:comments].insert(:post => comment[:post],
                    :name => comment[:name],
                    :email => comment[:email],
                    :body => comment[:body],
                    :timestamp => Time.now
                    )   
    MultiJson.dump({:status => "New comment posted."})
  end
end