class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions

  set :session_secret, "secret_courses"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/' do
    erb :index
  end
end