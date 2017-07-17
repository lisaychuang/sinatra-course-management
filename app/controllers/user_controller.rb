class UserController < ApplicationController
  
    get '/signup' do
        if logged_in?
            redirect to "/courses"
        else
            erb :"/users/new"
        end
    end

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


end