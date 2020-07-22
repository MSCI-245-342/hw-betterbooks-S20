# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


a1 = Author.create( name: "Orson Scott Card")
a2 = Author.create( name: "Suzanne Collins")
a3 = Author.create( name: "George Orwell")
a4 = Author.create( name: "Mark Twain")

b1 = Book.new( title: "Ender's Game", year: 1985 )
b1.author = a1 
b1.save

b2 = Book.new( title: "The Hunger Games", year: 2008)
b2.author = a2 
b2.save

b3 = Book.new( title: "1984", year: 1949 )
b3.author = a3
b3.save 

b4 = Book.new( title: "Catching Fire", year: 2009 )
b4.author = a2 
b4.save

bob = User.create( name: "Bob", email: "bob@bob.com")
mary = User.create( name: "Mary", email: "mary@mary.com")
sue = User.create( name: "Sue", email: "sue@sue.com")
fred = User.create( name: "Fred", email: "fred@fred.com")

#r1 = Rating.create( user: bob, book: b1, rating: 5 )
#r2 = Rating.create( user: bob, book: b3, rating: -3 )
#r3 = Rating.create( user: mary, book: b4, rating: 3 )
#r4 = Rating.create( user: mary, book: b3, rating: 5 )
#r5 = Rating.create( user: sue, book: b2, rating: 5 )

#rl1 = bob.readinglists.create(name: "May the odds be in my favor")
#rl1.books << b2
#rl1.books << b4

#rl2 = sue.readinglists.create( name: "Gotta Read")
#rl2.books << b3
#rl2.books << b1

#rl3 = fred.readinglists.create( name: "Sue's Favorite")
#rl3.books << b2