module FavoritesHelper
  def fave_or_unfave
    if @favorite
      button_to "Unlike", movie_favorite_path(@movie, @favorite), method: :delete
    else
      button_to "Like", movie_favorites_path(@movie)
    end
  end
end
