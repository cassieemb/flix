class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_movie, except: [:index, :new]

  def index
    case params[:filter]
    when 'upcoming'
      @movies = Movie.upcoming
    when 'released'
      @movies = Movie.released
    when 'recent'
      @movies = Movie.recent
    else
      @movies = Movie.all
    end
  end

  def show
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)
    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit

  end

  def destroy
    if @movie.destroy
      redirect_to movies_path, alert: "Movie successfully deleted!"
    else
      redirect_to @movie
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    if @movie.save
      redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new, status: 422
    end

  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: "Movie successfully updated!"
    else
      render :edit, status: 422
    end
  end

  private
  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

  def movie_params
      params.require(:movie).
        permit(:title, :description, :rating, :released_on, :total_gross, :director, :duration, :image_file_name, genre_ids: [])
  end
end
