require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  use Rack::Flash
  
  set :session_secret, "secret_courses"
  set :views, Proc.new { File.join(root, "../views/") }

  # User will only see homepage IF they are not currently logged in
  get '/' do
    if logged_in?
        redirect to "/courses"
    else
        erb :index
    end
  end

  # HELPER METHODS
  helpers do

    # Check if a user is logged into their account
    def logged_in?
      !!current_user
    end
    
    # Find current user
    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end

    # Find a course based on id
    def find_course(id)
      @course ||= Course.find_by_id(id)
    end

    # Display course difficulty based on level
    def course_difficulty(num)
      case num
        when 0
          "Easy"
        when 1
          "Intermediate"
        else
          "Advanced"
      end
    end

    # Display course registration status based on confirmation
    def registration_status(num)
      case num
        when 0
          "Pending"
        when 1
          "Waitlisted"
        else
          "Enrolled"
        end
    end
  end
end