class RemoveColumnFromMovies < ActiveRecord::Migration[7.0]
  def change
    remove_column :movies, :main_image, :string
  end
end
