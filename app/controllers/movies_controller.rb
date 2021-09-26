class MoviesController < ApplicationController

    def index

      # Get all the movie ratings (unique)
      @all_ratings = Movie.select(:rating).map(&:rating).uniq

      if params[:sort] || params[:ratings] # Check if defined
        
        puts "\n---------- Inside check for sorting/ratings ----------"

        puts "\n---------- Selected Sorting ----------"
        puts params[:sort]

        # Update the sorting-on-column check
        @sorting_on_column = params[:sort]

        # Extract the parameters for ratings
        @ratings = params[:ratings]
        puts "\n---------- Ratings Parameters Provided ----------"
        puts @ratings

        # Check if ratings are defined and handle accordingly
        @ratings ||= @all_ratings
        puts "\n---------- Modified Ratings ----------" 
        puts @ratings

        # Reference the responses going to the view
        @ratings = @ratings.keys if @ratings.respond_to?(:keys) 
        puts "\n---------- Final Ratings for reference ----------"
        puts @ratings

        @movies = Movie.where("rating IN (?)", @ratings).order(params[:sort])
      
      else
        @movies = Movie.all 
      end

    end  
  
    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
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