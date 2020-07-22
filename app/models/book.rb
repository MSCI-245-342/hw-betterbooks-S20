class Book < ApplicationRecord
  belongs_to :author
 
  validates_presence_of :title
  validates_length_of :title, maximum: 255
  validates_presence_of :year
  validates_numericality_of :year, only_integer: true, greater_than: 0, less_than: 2500  

  # Order books by year, author.name, or title
  def self.order_by field
    if field == 'year'
      return Book.order(:year, :title)
    elsif field == 'author'
      return Book.joins(:author).order(:name, :year)
    else
      return Book.order(:title)
    end
  end
end
