class Author < ApplicationRecord
  has_many :books    
    
  validates_presence_of :name
  validates_length_of :name, maximum: 70
    
  def num_books
     books.length     
  end
    
  # Creates and array of arrays to use in dropdown selects for author. For more info:  
  # https://guides.rubyonrails.org/form_helpers.html#select-boxes-for-dealing-with-model-objects
  def self.to_nested_array_for_select
     nested = []  
     Author.order(:name).each do |author|
         nested.push [author.name, author.id]
     end
     return nested 
  end
    

    
end
