class Movie < ApplicationRecord
  RATINGS = %w(G PG PG-13 R NC-17)
  before_save :set_slug

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  has_one_attached :main_image

  validates :released_on, :duration, presence: true
  validates :title, presence: true, uniqueness: true
  validates :description, length: {minimum: 25}
  validates :total_gross, numericality: {greater_than_or_equal_to: 0}
  validates :rating, inclusion: {in: RATINGS, message: "%{value} is not a valid rating."}

  validate :acceptable_image

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

  def acceptable_image
    return unless main_image.attached?

    unless main_image.blob.byte_size <= 1.megabyte
      errors.add(:main_image, "is too big")
    end

    acceptable_types = %w[image/jpeg image/png]

    unless acceptable_types.include?(main_image.content_type)
      errors.add(:main_image, "must be JPEG or PNG")
    end
  end

  def set_slug
    self.slug = title.parameterize
  end
end
