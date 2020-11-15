class WordcountsController < ApplicationController

    get '/counts' do
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            # @user = User.find(session[:user_id])
            @wordcounts = Wordcount.all.sort_by { |count| [count[:year], count[:month], count[:day], count[:id]] }.reverse
            erb :'wordcounts/index'
        end
    end

    get '/counts/new' do
        if Helpers.logged_in?(session)
            erb :'wordcounts/new'
        else
            redirect "/login"
        end
    end

    post '/counts' do
        if !Helpers.logged_in?(session)
            redirect "/login"
        elsif !params.select { |k,v| v.empty? }.empty? # CHECK IF ANY FIELDS ARE EMPTY: having empty fields returns "FALSE" and NO empty fields returns "TRUE"
            redirect "/counts/new"
        else 
            Helpers.convert_to_i(params) #=> Converts all string values into integers
        end

        if Wordcount.valid_date?(params)
            wordcount = Helpers.current_user(session).wordcounts.create(params)
            redirect "/counts/#{wordcount.id}"
        else
            redirect "/counts/new"
        end
    end

    get '/counts/:id' do
        @wordcount = Wordcount.all.find(params[:id])
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            erb :'wordcounts/show'
        end
    end

    get '/counts/:id/edit' do
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            # binding.pry
            @wordcount = Wordcount.find(params[:id])
            if @wordcount.user_id != session[:user_id]
                redirect "/counts/#{params[:id]}"
            else
                erb :'wordcounts/edit'
            end
        end
    end

    patch '/counts/:id' do
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            @wordcount = Wordcount.find(params[:id])
            # params.each { |k, v| params.delete(k) if v.empty? }
            if @wordcount.user_id != session[:user_id]
                redirect "/counts/#{@wordcount.id}"
            elsif Helpers.delete_empty_keys(params).empty?
                redirect "/counts/#{@wordcount.id}/edit"
            else
                Helpers.ready_for_update(params) #=> Deletes empty keys, deletes "_method" key, converts all string values into integers
                @wordcount.update(params)
                redirect "/counts/#{@wordcount.id}/edit"
            end
        end
    end

    delete '/counts/:id' do
        @wordcount = Wordcount.find(params[:id])
        if @wordcount.user_id == session[:user_id]
            @wordcount.destroy
            redirect "/counts"
        else
            redirect "/counts/#{@wordcount.id}"
        end
    end
    
end