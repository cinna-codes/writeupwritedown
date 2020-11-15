class Wordcount < ActiveRecord::Base
    belongs_to :user

    def self.valid_date?(params = {})
        if (params[:year] > Time.now.year) || params[:month] < 1 || params[:month] > 12 || params[:day] < 1 || params[:day] > 31
            false
        elsif !(params[:day] <= 29) && (month == 2 && (year % 4 == 0))
            false
        elsif !(params[:day] <= 28) && month == 2
            false
        elsif !(params[:day] <= 30) && month.even?
            false
        elsif !(params[:day] <= 31) && month.odd?
            false
        else
            Time.new(params[:year], params[:month], params[:day]) <= Time.now
        end
    end
end