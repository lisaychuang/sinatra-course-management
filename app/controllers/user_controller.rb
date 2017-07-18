class UserController < ApplicationController
    # Only new user will see the signup page
    get '/signup' do
        if logged_in?
            redirect to "/courses"
        else
            erb :"/users/new"
        end
    end

    # CREATE a new user based on form information
    post '/signup' do
        @user = User.create(full_name: params[:full_name], username: params[:username], email: params[:email], password: params[:password])
        @user.instructor = true if params[:instructor] == "yes"

        if @user.save
            session[:user_id] = @user.id
            redirect to "/courses"
        else
            redirect to "/signup"
        end
    end

    # User currently logged in will view the Courses page directly
    get '/login' do
        if logged_in?
            redirect to "/courses"
        else
            erb :"/users/login"
        end
    end

    # Verify user information to Log In
    post '/login' do
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to "/courses"
        else
            redirect to "/login"
        end
    end

    # Log Out process
    get '/logout' do
        if logged_in?
            session.clear
            redirect to "/login"
        else
            redirect to "/"
        end
    end

    # Student can view courses enrolled & registration status
    get '/enrolled' do
        @enrollments = UserCourse.where(user_id: current_user.id)

        erb :"/courses/my_enrollment"
    end

    # Instructors can view courses they are teaching
    get '/teaching' do
        @courses = Course.all.map {|course|
            course.id if course.instructor_id === current_user.id}
        @my_courses = @courses.compact.map{|c| Course.find_by_id(c)}
        
        erb :"/courses/my_courses"
    end

    # READ a single user information
    get "/users/:id" do 
        @user = User.find_by_id(params[:id])
        erb :"/users/show"
    end

    # User can only EDIT their account information 
    get "/users/:id/edit" do 
        if current_user.id === params[:id].to_i
            erb :"/users/edit"
        else
            redirect to "/users/#{params[:id]}"
        end
    end

    # UPDATE user information based on form data
    patch "/users/:id" do
        if current_user.authenticate(params[:old_password])
            current_user.update(biography: params[:biography], email: params[:email], password: params[:new_password])
            redirect to "/users/#{current_user.id}"
        else
            redirect to "/users/#{current_user.id}/edit"
        end
    end

end