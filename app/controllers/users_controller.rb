class UsersController < ApplicationController

    get '/signup' do
        if Helpers.logged_in?(session)
            redirect "/counts"
        end
        erb :'users/signup'
      end

    post '/signup' do
        if params[:username] == "" || params[:password] == "" || params[:email] == "" #=> Every field has to be filled out. Have to check for duplicates later
            redirect "/signup"
        elsif !!User.find_by(username: params[:username]) || !!User.find_by(email: params[:email])
            redirect "/signup"
        else
            user = User.create(username: params[:username], password: params[:password], email: params[:email])
            session[:user_id] = user.id
            redirect "/counts"
        end
    end

    get '/login' do
        if Helpers.logged_in?(session)
            redirect "/counts"
        else
            erb :'users/login'
        end
    end

    post "/login" do
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect "/counts"
        else
            redirect "/login"
        end
    end

    get '/logout' do
        if Helpers.logged_in?(session)
            session.clear
        end
            redirect "/login"
    end

    get '/users/:slug' do
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            @user = User.find_by_slug(params[:slug])
            @wordcounts = @user.wordcounts.sort_by { |count| [count[:year], count[:month], count[:day], count[:id]] }.reverse
            erb :'users/show'
        end
    end

end