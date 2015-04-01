require_relative "lib/easycomments.rb"
require_relative "lib/easycomments/ec_model.rb"

class EC < Sinatra::Application

  include ECModel

  before do
    content_type 'application/json'
  end

  if ALLOW_CORS
    use Rack::Cors do
      allow do
        origins CORS_ORIGIN
        resource '/comments', :headers => :any, :methods => :get
        resource '/comment', :headers => :any, :methods => :post
      end
    end
    use Rack::Protection::FrameOptions
    use Rack::Protection::PathTraversal
    use Rack::Protection::IPSpoofing
  else
    use Rack::Protection::FrameOptions
    use Rack::Protection::PathTraversal
    use Rack::Protection::IPSpoofing  
    use Rack::Protection::HttpOrigin
  end


  get "/comments" do
    get_comments(params[:post], params[:page])
  end

  post "/comment" do
    post_comment(params)
  end

  get "/" do
    redirect "/dashboard"
  end
  
end