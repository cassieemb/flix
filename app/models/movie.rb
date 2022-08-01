class Movie < ApplicationRecord

  def flop?
    unless total_gross == nil
      total_gross < 225000000 || total_gross == blank?
    end
  end
end
