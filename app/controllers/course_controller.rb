class CourseController < ApplicationController
    
    get '/courses' do
        @courses = Course.all
        @current_user = current_user
        
        erb :"/courses/index"
    end

    # only instructors can create new courses
    get '/courses/new' do
        if current_user.instructor 
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
        @course = Course.find_by_id(params[:id])
        if logged_in?
            erb :"/courses/show"
        else
            redirect to "/login"
        end
    end

    patch '/courses/:id' do
        @course = Course.find_by_id(params[:id])
        @course.update(name: params[:name], icon: params[:icon], description: params[:description], level: params[:level].to_i-1)

        if current_user.instructor && current_user.id === @course.instructor.id
            binding.pry
            if @course.save
                flash[:message] = "Successfully edited course."
                redirect to "/courses/#{@course.id}"
            else 
                flash[:message] = "Something went wrong. Please try to edit course again."
                redirect to "/courses/#{@course.id}"
            end
        else
            redirect to "/courses/#{@course.id}"
        end
    end

    post '/courses/:id/registration' do
    end

end