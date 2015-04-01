require_relative "lib/easycomments.rb"
require_relative "lib/easycomments/ec_dashboard_model.rb"

class ECDashboard < Sinatra::Application

  include ECDashboardModel
  
  before do
    content_type 'application/json'
  end

  get "/" do
    content_type 'text/html'
    send_file 'views/index.html'
  end

  post '/login' do
    authenticate(params[:username], params[:password])
  end

  get "/comments" do
    get_comments(params[:post], params[:page])
  end

  get '/get_all_posts' do
    get_all_posts
  end

  post '/edit_comment' do
    edit_comment(params[:id], params[:new_body])
  end

  post '/remove_comment' do
    remove_comment(params[:id])
  end

  post '/change_approval_status' do
   comment_change_approval(params[:id])
  end

  get '/get_total_pending' do
    get_total_pending
  end

  get '/get_posts_with_pending' do
    get_posts_with_pending
  end

  get '/get_pending_comments' do
    get_pending_comments(params[:post], params[:page])
  end

  post '/ignore_comment' do
    ignore_comment(params[:id])
  end

end