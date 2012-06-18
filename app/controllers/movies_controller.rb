class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort]
    @all_ratings = Movie.ratings

    if params[:ratings]!=nil then
      @selected_ratings = params[:ratings].keys
      @movies = Movie.where(:rating => @selected_ratings)
    else
      @selected_ratings = []
      @movies = {}
    end

    if @sort == "by_title" then
      raise params[:ratings].inspect
      @movies = @movies.sort_by {|m| m.title}
    end
    if @sort == "by_release_date" then
      raise params[:ratings].inspect
      @movies = @movies.sort_by {|m| m.release_date}
    end	 
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
