class Movie < ApplicationRecord
  RATINGS = %w(G PG PG-13 R NC-17)
  validates :title, :released_on, :duration, presence: true
  validates :description, length: {minimum: 25}
  validates :total_gross, numericality: {greater_than_or_equal_to: 0}
  validates :rating, inclusion: {in: RATINGS, message: "%{value} is not a valid rating."}

  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }


  def self.released
    Movie.where("released_on < ?", Time.now).order("released_on desc")
  end

  def flop?
    unless total_gross == nil
      total_gross < 225000000 || total_gross == blank?
    end
  end
end
