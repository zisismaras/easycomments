require './ec'
require './dashboard'

run Rack::Builder.new {
  map "/" do
    run EC.new
  end

  map "/dashboard" do
    run ECDashboard.new
  end
}