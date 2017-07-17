class CourseController < ApplicationController

    get '/courses' do
        @courses = Course.all
        erb :"/courses/index"
    end


end