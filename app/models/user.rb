class User < ActiveRecord::Base
    has_secure_password
    has_many :wordcounts

    def slug
        self.username.strip.downcase.gsub(" ", "-")
    end

    def self.find_by_slug(slug)
        User.all.find { |user| user.slug == slug }
    end
end

# test users:

# writewritewrite
# pass
# write@test.com

# Inky
# pass
# inky@test.com