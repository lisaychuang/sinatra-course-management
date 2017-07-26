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
        if params[:instructor] == "yes"
            @user.instructor = true
        else 
            @user.instructor = false
        end

        if @user.save
            session[:user_id] = @user.id
            redirect to "/courses"
        else
            flash[:error] = "Please ensure you have filled in all required fields correctly!"
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
            flash[:error] = "Sorry, we were not able to find a user with that username and password."
            redirect to "/login"
        end
    end

    # Log Out process
    get '/logout' do
        if logged_in?
            session.clear
            flash[:message] = "You have logged out successfully!"
            redirect to "/login"
        else
            redirect to "/"
        end
    end

    # View list of all users
    get '/users' do
        @instructors = User.where(instructor: true)
        @students = User.where(instructor: false)
        
        if logged_in?
            erb :"/users/index"
        else
            flash[:status] = "You are not currently logged in!"
            redirect to :"/login"
        end
    end
    
    # Student can view courses enrolled & registration status
    get '/enrolled' do

        if logged_in?
            @enrollments = UserCourse.where(user_id: current_user.id)
            if !current_user.instructor 
                erb :"/courses/my_enrollment"
            else
                redirect to :"/courses"
            end
        else
            redirect to :"/login"
        end
    end

    # Student can update courses enrolled
    get '/update_enrollment' do
        if logged_in?
            if !current_user.instructor
                @enrollments = UserCourse.where(user_id: current_user.id)
                erb :"/courses/edit_my_enrollment"
            else
                flash[:error] = "You are not a student!"
            redirect to :"/courses"
            end
        else
            flash[:status] = "You are not currently logged in!"
            redirect to :"/login"
        end
    end

    # Update enrollment request note from form input
    patch '/update_enrollment' do
        @student_enrollment = UserCourse.find_by_id(params[:id].first[0].to_s)
        @student_enrollment.update(notes: params[:enrollment])
        redirect to "/enrolled"
    end

    # Delete student's own enrollment request
    delete '/delete_enrollment' do
        @student_enrollment = UserCourse.find_by_id(params[:id].first[0].to_s)

        if @student_enrollment.user_id == current_user.id
            @student_enrollment.destroy
            redirect to "/enrolled"
        else
            redirect to "/courses"
        end
    end


    # Instructors can view courses they are teaching
    get '/teaching' do
        if logged_in?
            if current_user.instructor
                @courses = Course.all.map {|course|
                    course.id if course.instructor_id === current_user.id}
                @my_courses = @courses.compact.map{|c| Course.find_by_id(c)}
            
                erb :"/courses/my_courses"
            else
                redirect to "/courses"
            end
        else
            redirect to :"/login"
        end
    end

    # READ a single user information
    get '/users/:id' do 
        @user = User.find_by_id(params[:id])

        if logged_in?
            erb :"/users/show"
        else
            redirect to :"/login"
        end
    end

    # User can only EDIT their account information 
    get '/users/:id/edit' do 
        if logged_in?
            if current_user.id === params[:id].to_i
                erb :"/users/edit"
            else
                redirect to "/users/#{params[:id]}"
            end
        else
            redirect to :'/login'
        end
    end

    # UPDATE user information based on form data
    patch '/users/:id' do
        if current_user.id === params[:id].to_i
            if current_user.authenticate(params[:old_password])
                current_user.update(biography: params[:biography], email: params[:email], password: params[:new_password])
                flash[:message] = "You profile and password has been updated successfully!"
                redirect to "/users/#{current_user.id}"
            else
                current_user.update(biography: params[:biography], email: params[:email])

                flash[:message] = "You profile has been updated successfully!"
                redirect to "/users/#{current_user.id}"
            end
        else
            flash[:error] = "You profile was not updated, please try again."
            redirect to "/users/#{params[:id]}"
        end
    end

    # User can DELETE their own account
    delete '/users/:id' do
        if current_user.id === params[:id].to_i
            current_user.destroy
            flash[:deleted] = "User deleted"
            redirect to "/"
        else
            flash[:error] = "You are not permitted to delete this user!"
            redirect to "/users"
        end
    end

end