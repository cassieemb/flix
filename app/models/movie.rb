class Movie < ApplicationRecord
  RATINGS = %w(G PG PG-13 R NC-17)
  before_save :set_slug

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  validates :released_on, :duration, presence: true
  validates :title, presence: true, uniqueness: true
  validates :description, length: {minimum: 25}
  validates :total_gross, numericality: {greater_than_or_equal_to: 0}
  validates :rating, inclusion: {in: RATINGS, message: "%{value} is not a valid rating."}
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
      (average_stars / 5.0) * 100.0
  end

  scope :released, -> { where("released_on < ?", Time.now).order("released_on desc")}
  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
  scope :recent, -> (max=5) { released.limit(max)}
  scope :flop, -> { released.where("total_gross < 225000000").order(total_gross: :asc) }
  scope :hits, -> { released.where("total_gross >= 300000000").order(total_gross: :desc) }

  def flop?
    unless total_gross == nil
      total_gross < 225000000 || total_gross == blank?
    end
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = title.parameterize
  end
end
