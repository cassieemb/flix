module ReviewsHelper
  def average_stars(movie)
    if movie.average_stars.zero?
      content_tag(:strong, 'No Reviews')
    else
      content_tag(:strong, pluralize(number_with_precision(movie.average_stars, precision: 1), "star"))
    end
  end
end
