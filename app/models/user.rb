class User < ApplicationRecord   
    validates_presence_of :name
    validates_length_of :name, maximum: 70    
    validates_presence_of :email
    validates_length_of :email, maximum: 255
    validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i 
end
