class CourseController < ApplicationController
    
    # View all courses
    get '/courses' do
        if logged_in?
            @courses = Course.all
            erb :"/courses/index"
        else
            flash[:error] = "You are not currently logged in!"
            redirect to :"/login"
        end
    end

    # Instructor can view form to create a new course
    get '/courses/new' do
        if logged_in?
            if current_user.instructor 
                erb :"/courses/new"
            else
                flash[:error] = "You are not an instructor!"
                redirect to "/courses"
            end
        else
            redirect to :"/login"
        end
    end

    # Instructor CREATE a new course
    post '/courses' do
        @new_course = Course.create(name: params[:name], icon: params[:icon], description: params[:description], level: params[:level].to_i-1, instructor_id: session[:user_id])

        if @new_course.save 
            flash[:message] = "Course created"
            redirect to "/teaching"
        else
            flash[:error] = "Please ensure you have filled in all required fields correctly!"
            redirect to "/courses/new"
        end
    end

    # All users can view a single course page
    get '/courses/:id' do
        @course = find_course(params[:id])
        @course_enrollment = UserCourse.where(course_id: params[:id])
        @existing_registration = nil
        if !current_user.instructor
                @existing_registration = UserCourse.where("course_id = ? AND user_id = ?", params[:id], current_user.id).first
            end

        if logged_in?
            erb :"/courses/show"
        else
            flash[:error] = "You are not currently logged in!"
            redirect to "/login"
        end
    end

    # Instructor can update student enrollment status
    post '/courses/:id/enrollment' do
        @course = find_course(params[:id])
        if current_user.instructor && current_user.id === @course.instructor.id
            @student_enrollment = UserCourse.find_by_id(params[:confirmation][0].to_i)
            @student_enrollment.update(confirmation: params[:confirmation][2].to_i)

            flash[:message] = "Student registrations updated!"
            redirect to "/courses/#{@course.id}"
        else
            redirect to "/courses/#{@course.id}"
        end
    end

    # Instructor can EDIT a course information
    get '/courses/:id/edit' do
        @course = find_course(params[:id])
        if current_user.instructor && current_user.id === @course.instructor.id
            erb :"/courses/edit_course"
        else
            flash[:error] = "You are not an instructor!"
            redirect to "/courses/#{@course.id}"
        end
    end

    # Instructor can UPDATE course based on form input
    patch '/courses/:id' do
        @course = find_course(params[:id])
        @course.update(name: params[:name], icon: params[:icon], description: params[:description], level: params[:level].to_i-1)

        if current_user.instructor && current_user.id === @course.instructor.id
            if @course.save
                flash[:message] = "Successfully edited course."
                redirect to "/courses/#{@course.id}"
            else 
                flash[:message] = "Something went wrong. Please try to edit course again."
                redirect to "/courses/#{@course.id}/edit"
            end
        else
            redirect to "/courses/#{@course.id}"
        end
    end

    # Instructor can DELETE their own courses
    delete '/courses/:id' do
        @course = find_course(params[:id])
        if current_user.id === @course.instructor.id
            @course.destroy
            flash[:deleted] = "Course deleted"
            redirect to "/teaching"
        else
            redirect to "/courses"
        end
    end

    # Student can UPDATE course registration
    post '/courses/:id/registration' do
        @course = find_course(params[:id])
        @new_enrollment = UserCourse.create(notes: params[:notes], user_id: current_user.id, course_id: params[:id])
        
        if @new_enrollment.save
            flash[:message] = "Successfully registered for this course."
            redirect to "/courses/#{@course.id}"
        else 
            flash[:error] = "Something went wrong. 
                Please try to register for this course again, remember to include a Request Note to your instructor!"
                redirect to "/courses/#{@course.id}"
        end
    end

end