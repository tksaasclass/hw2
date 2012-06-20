class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # First update parameters and redirect if necessary
    redirect = false
    if params[:sort] != nil then
      session[:sort] = params[:sort]
    else
      if session[:sort] != nil then
	params[:sort] = session[:sort]
	redirect = true
      end
    end 
    if params[:ratings] !=nil then
      session[:ratings] = params[:ratings]
    else
      if session[:ratings] !=nil then
	params[:ratings] = session[:ratings]
	redirect = true
      end
    end
   
    if redirect then
      flash.keep
      redirect_to movies_path(:sort => params[:sort],:ratings => params[:ratings])
    end

    @sort = params[:sort]
    @all_ratings = Movie.ratings

    if params[:ratings]==nil then
      @selected_ratings = {}
      @movies = {}
    else
      @selected_ratings = params[:ratings]
      @movies=Movie.find(:all, :conditions => {:rating => @selected_ratings.keys}, :order => @sort)
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
