class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      session.clear unless request.url.include? "/movies"
      
      session[:ratings] = params[:ratings] if params[:ratings] != nil
      session[:sort_by] = params[:sort_by] if params[:sort_by] != nil
      # session[:home] = false
      
      if(params[:sort_by].nil? && params[:ratings].nil?)
        if(!session[:sort_by].nil? && !session[:ratings].nil?)
          redirect_to movies_path(:sort_by=>session[:sort_by], :ratings=>session[:ratings], :home => true)
        elsif(!session[:sort_by].nil?)
          redirect_to movies_path(:sort_by=>session[:sort_by], :home => true)
        elsif(!session[:ratings].nil?)
          redirect_to movies_path(:ratings=>session[:ratings], :home => true)
        end
      elsif(params[:sort_by].nil? && !session[:sort_by].nil?)
        redirect_to movies_path(:sort_by=>session[:sort_by], :ratings=>params[:ratings], :home => true)
      elsif(params[:ratings].nil? && !session[:ratings].nil?)
        redirect_to movies_path(:ratings=>session[:ratings], :sort_by=>params[:sort_by], :home => true)
      end
      
      @sort = params[:sort_by]
      @all_ratings = Movie.all_ratings
    
      if params[:ratings].nil?
        @ratings_filter = @all_ratings
      else
        @ratings_filter = params[:ratings].keys
      end
      
      @movies = Movie.with_ratings(@ratings_filter, @sort)

    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end