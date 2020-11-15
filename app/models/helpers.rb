class Helpers
    def self.logged_in?(session = {})
        !!session[:user_id]
    end

    def self.current_user(session = {})
        User.find(session[:user_id])
    end

    def self.delete_empty_keys(params_hash = {})
        params_hash.each { |k, v| params_hash.delete(k) if v.empty? }
    end

    def self.convert_to_i(params_hash = {})
        params_hash.each { |k, v| params_hash[k] = v.to_i } #=> returns/permanently changes the hash argument
    end

    def self.ready_for_update(params_hash = {})
        Helpers.delete_empty_keys(params_hash) #=> Have to delete empty keys first, because calling `.empty?` on an integer throws an error e.g. `2.empty?`
        params_hash.each { |k, v| params_hash.delete(k) if k == "_method" }
        Helpers.convert_to_i(params_hash)
    end
end