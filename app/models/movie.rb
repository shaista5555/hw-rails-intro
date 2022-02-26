class Movie < ActiveRecord::Base
    # def self.all_ratings
    #     self.select(:rating).map(&:rating).uniq
    # end
    
    # def self.with_ratings(ratings_list, header: nil)
    #     ratings = ratings_list.present? ? ratings_list.keys : all_ratings
    #     ratings = ratings.map { |rating| rating.upcase }
    #     return self.where(rating: ratings) unless header.present?
    #     return self.where(rating: ratings).order(header) if header.present?
    # end
    def self.all_ratings
        self.select(:rating).map(&:rating).uniq
    end
    
    def self.with_ratings(ratings_list, sort)
        # if ratings_list.is_a? Array
        movies = self.where( { rating: ratings_list }).order(sort)
        # else
            # ratings_list_keys = ratings_list.keys
            # movies = self.where( { rating: ratings_list_keys }).order(sort)
        # end
        return movies
    end
end