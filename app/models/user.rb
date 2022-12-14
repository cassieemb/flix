class User < ApplicationRecord
  has_secure_password
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true
  validates :email, format: {with: /\S+@\S+/}, uniqueness: { case_sensitive: false}
  validates :password, length: {minimum: 10, allow_blank: true}
  validates :username, presence: true, uniqueness: { case_sensitive: false}, format: {with: /\A[A-Z0-9]+\z/i}
end
