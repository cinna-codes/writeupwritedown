class UsersController < ApplicationController

    get '/signup' do
        if Helpers.logged_in?(session)
            redirect "/counts"
        end
        erb :'users/signup'
      end

    post '/signup' do
        # https://guides.rubyonrails.org/active_record_validations.html

        user = User.new(params)
        if user.save
            redirect "/counts"
        else
            flash[:error] = "All fields must be filled out. No two users can have the same username or email."
            redirect "/signup"
        end
        
        # if params[:username] == "" || params[:password] == "" || params[:email] == "" #=> Every field has to be filled out. Have to check for duplicates later
        #     flash[:empty_fields] = "All fields must be filled out."
        #     redirect "/signup"
        # elsif !!User.find_by(username: params[:username]) || !!User.find_by(email: params[:email]) || !!User.find_by_slug(params[:username].strip.downcase.gsub(" ", "-"))
        #     flash[:not_unique] = "Usernames and emails must be unique."
        #     redirect "/signup"
        # else
        #     user = User.create(username: params[:username], password: params[:password], email: params[:email])
        #     session[:user_id] = user.id
        #     redirect "/counts"
        # end
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