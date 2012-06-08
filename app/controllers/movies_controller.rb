class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:sort].nil?
      unless session[:sort].nil?
        flash.keep
        redirect_to movies_path(request.parameters.merge( {:sort => session[:sort]} ))
        return
      end 
    else
      session[:sort] = params[:sort] 
    end
    if params[:ratings].nil?
      unless session[:ratings].nil?
        flash.keep
        redirect_to movies_path(request.parameters.merge( {:ratings => session[:ratings]} ))
        return
      end 
    else
      session[:ratings] = params[:ratings] 
    end
    @all_ratings = Movie.list_ratings
    unless params[:ratings].nil?
      @current_ratings = params[:ratings].keys
    else
      @current_ratings = []
    end 
    query_args = {}
    unless params[:sort].nil?
      case
        when params[:sort] == "title"
          @sort_title = "hilite"
          query_args[:order] = "title ASC"
        when params[:sort] == "release_date"
          @sort_release_date = "hilite"
          query_args[:order] = "release_date ASC"
      end
    end 
    if @current_ratings.length > 0
      @movies = Movie.where(:rating => @current_ratings).order(query_args[:order])
    else
      @movies = Movie.all(query_args)
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
