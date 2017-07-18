class CourseController < ApplicationController

    get '/courses' do
        @courses = Course.all
        @current_user = User.find_by_id(session[:user_id])
        
        erb :"/courses/index"
    end

    # only instructors can create new courses
    get '/courses/new' do
        @current_user = User.find_by_id(session[:user_id])

        if @current_user.instructor 
            erb :"/courses/new"
        else
            redirect to "/courses"
        end
        
    end

    post '/courses' do
        @new_course = Course.create(name: params[:name], icon: params[:icon], description: params[:descrciption], level: params[:level].to_i-1, instructor_id: session[:user_id])
        @new_course.save
        redirect to "/courses"
    end

    get '/courses/:id' do
    end


end