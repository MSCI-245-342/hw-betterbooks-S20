# hw-betterbooks

In this assignment, you are going to add some features to an existing web app.  The web app, BetterBooks, uses a subset of the tables you worked with in the last homework.  

First, I'm going to show you how I made the web app, and then I'll explain the tasks for you to complete.

## Background Reading

While the web and the textbook have basic coverage of Rails, I found the following chapters from [Learning Rails 5](https://learning.oreilly.com/library/view/learning-rails-5/9781491926185/) to be the most helpful to understand what was going on (reminder: as a UWaterloo student, you have free access to this book):
1. [Chapter 5: Accelerating Development with Scaffolding](https://learning.oreilly.com/library/view/learning-rails-5/9781491926185/ch05.html#accelerating_development_with_scaffoldin)

1. [Chapter 6: Presenting Models with Forms](https://learning.oreilly.com/library/view/learning-rails-5/9781491926185/ch06.html#presenting_models_with_forms_content)

1. [Chapter 7: Strengthening Models with Validation](https://learning.oreilly.com/library/view/learning-rails-5/9781491926185/ch07.html#strengthening_models_with_validation)

I will not cover the material in this homework at the same level of detail as this book or various reference manuals.  

### Rails 5 vs 6

While we are using Rails 6, the book above covers Rails 5.  Chapter 6, uses form_for rather than form_with, but other than their names, there is very little different between them.  Rails combined the functionality of form_tag and form_for into one new form helper called form_with.  Certainly there are some other differences, but they are not significant to the concepts explained in the book, which are the important things to learn. 

## Getting up and running

You are reading these instructions having cloned your GitHub repository to a directory named `betterbooks`.  

If you do not have a directory named betterbooks, stop!  Go back to the instructions in Learn and correctly clone your repository.

To get up and going, do the following:
```
cd betterbooks
bundle install --without production
rails db:create db:migrate db:seed
rails server -b 0.0.0.0
```
You should now be able to go to your "Box URL in Codio and see the web app.

## How I built BetterBooks 

### Basic empty app

After cloning an empty repository to a directory named betterbooks, I ran the following command: (Do **not** do this! You already have the working app.)
```
rails new . --skip-javascript --skip-test --skip-action-mailer --skip-action-mailbox --skip-action-text --skip-action-cable --skip-active-storage --skip-keeps --skip-spring --skip-sprockets --skip-turbolinks --database=postgresql
```
This makes the stripped down version of a Rails app and does not use javascript, which we haven't learned.

Then, in the Gemfile, I commented out the `jbuilder` gem.  This prevents all sort of JSON code being generated, which we don't need.

I then reran bundle install, and created and migrated the database.

To get the web app to work on Codio, I added the following to `config/environments/development.rb`:
```
config.hosts << /[a-z0-9]+\-[a-z0-9]+\-3000\.codio\.io/
```
this should allow it to work on any Codio host in development mode.

I then tested that I could get `yay! you're on rails` with `rails server -b 0.0.0.0` and going to my "Box URL".

### Scaffolding

We've learned in previous homework about using Rails to generate models, controllers, and migrations.  We can also get Rails to generate all these for RESTful resources in one command using what is called "scaffolding".

I generated three models: Author, User, Book, and their associated controllers and migrations and routes using these commands:
```
rails generate scaffold User name:string email:string
rails generate scaffold Author name:string
rails generate scaffold Book title:string year:integer author:references
```
As you can see, these generate commands are effectively the same as I used for generating the models and migrations in the last homework, except instead of asking for a migration or model, I ask for a scaffold.  

The scaffolding gives a lot of working code, but it also has issues that need to be fixed.  The code in BetterBooks represents what I think is a simplified conversion of the scaffolding, where I simplified code to make it easier to understand.  

When it comes to your final project, should you generate scaffolding?  You could give it a try, and then compare what you get to what you have in this project and decide what to keep and what to change.  Or, you can just generate the models and controllers as we did in the previous homework.  Most professional projects do not bother with scaffolding, but instead generate more specific components and hand edit them.  Either way, you always have to edit the generated code to get it the way you want.  I used the scaffolding to get a working example put together faster.

## Order of Work

After you have the basics of models and controllers generated for you, what order should you work on the parts of a project, e.g. your final project in MSCI 245?

1. Get your migrations correct.  You should not work on anything until your migrations are built to match your desired database design.  Make sure:  
   + You have all primary key and foreign keys correctly setup.
   + You have placed the correct "NOT NULL" and size limits on attributes.

1. Get your model associations correct.  

1. Add validations to your models (see below).

1. Create your seed data and load it.  

1. Determine what your routes are going to be, and make sure `rails routes` reports the correct routes.

1. Work on your controllers and views.  As you need functionality, put most of it in your models.  Your controllers and views should be as sparse and lightweight as possible.

Missing from this list is testing.  As you do work, remember to constantly test it to make sure it is working correctly.  In MSCI 342, we will cover how to systematically test, but for now, you have to do your best to check and verify your work with your own test cases.

## 1. Migrations

To get my migrations right, I copied them from the last homework.

## 2. Model Associations

Again, I copied my associations from the last homework.

## 3. Validations

With our proper database design, we have a strong first line of defense against our database have bad data in it.  For example, our foreign keys make sure we don't reference items that don't exist.  Preventing null values makes sure we always have a value where we need one.  Never let your database go unprotected at the database level!

We cannot easily do all of our data control at the database level.  Certainly we can write check constraints, but lots of these will be easier to implement in our models.  For example, we can check email addresses for a correct format much easier in our User model than in the database.

In past homework, we've hacked together our own checks on the data being input from the user.  

Rails has lots of support for validating user input and making sure that we don't save garbage to our database.  

### Validations added to models

The Author model is the simplest with only a name attribute.  I decided that I wanted `name` to never be blank (either the empty string or nil) and I wanted the model to enforce the same length limit we used on the database: 70 characters.  If we don't catch a nil or a too long string at the model level, when we try to save the data in the database, it will raise an exception and our app will just not work.  

To make sure `name` is not blank, I added the following to the Author model:
```
validates_presence_of :name
```
Manual: [validates_presence_of](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_presence_of)

To limit the length of `name`, I added:
```ruby
validates_length_of :name, maximum: 70
```
Manual: [validates_length_of](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_length_of)

If we do a Author.create() or make a new Author and then try to save it, and `name` violates these validations, the save will fail.  

In addition, on our author object that we tried to save, there will be a method named `errors` that return an array that contains an explanation about each failed validation.

The beauty of this is that we use validations as follows in the web app:

1. Display a form for creating a new Author.

1. User fills out the form and submits it.

1. We grab the inputs from the user, and initialize a new Author object with them.

1. We then try to save the new Author object to the database, but if it fails, then messages are made available via the `errors` method.  

1. When a save fails, we render the `new` form again, but this time display the error messages to the user so that they know what to fix.  Plus, we use the values the user gave us to populate the form so that the user doesn't have to retype everything.

1. If the save succeeds, we redirect to the show author page for the new author.

We'll look at the form later in more detail.

#### User model validations:

To the User model, I added the following validations:

```ruby
    validates_presence_of :name
    validates_length_of :name, maximum: 70    
    validates_presence_of :email
    validates_length_of :email, maximum: 255
    validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i 
```

The new one here is [validates_format_of](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_format_of) to make sure the email is the correct format.

#### Book model validations:

For the Book model:

```ruby
  validates_presence_of :title
  validates_length_of :title, maximum: 255
  validates_presence_of :year
  validates_numericality_of :year, only_integer: true, greater_than: 0, less_than: 2500  
```

The [validates_numericality_of](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_numericality_of) can be used to make sure we get a number.  I also used it to only accept years greater than 0 and less than 2500.

### Try out the web app

Go, use the web app now and try adding invalid data into the app.  


### Other Validations of Use 

There are lots of other validations possible, and you can write custom validations, but these are two important ones:

#### Uniqueness

We can make sure an entry is unique in the database.  For example, many authentication systems want each user to have a unique email:

```ruby
validates :email, uniqueness: true
```

If we have a uniqueness validation on a field, we should also enforce this
in the database with a unique index.

We would use this in a migration:

```ruby
add_index :table_name, :column_name, unique: true
```

For more info:

https://guides.rubyonrails.org/active_record_validations.html#uniqueness

https://api.rubyonrails.org/classes/ActiveRecord/Migration.html


#### Inclusion in a set

If we only want certain values entered in a field, for example:

```ruby
validates :color, inclusion: { in: %w(red gold),
    message: "must be red or gold" }
```

More info:

https://guides.rubyonrails.org/active_record_validations.html#inclusion

## 4. Seed Data

I copied the seed data I used in the last homework.

## 5. Routes 

The scaffolding made most of the routes needed with 3 statements:

```ruby
  resources :books
  resources :users
  resources :authors
```

I also want a root (home page at `/`), and so I'll need a controller for this page.  I'll call it the static_pages controller, and so I added this route:

```ruby
root to: 'static_pages#home'
```

This says that '/' should go to the static_pages controller and run the `home` action.  

I also wanted to add pages to the app for the confirmation of a request to delete users and authors, and so I needed a route for these pages.  I modeled the routes after the `edit` routes:

```ruby
  get 'users/:id/confirm_delete', to: 'users#confirm_delete', as: 'confirm_delete_user'

  get 'authors/:id/confirm_delete', to: 'authors#confirm_delete', as: 'confirm_delete_author'
```

So, for example, when a user goes to `authors/5/confirm_delete`, I will show them a form asking them if they really want to delete the author with id=5, and if so, they submit that form to the delete/destroy route.  The `as:` option sets up helper methods: `confirm_delete_user_path` and `confirm_delete_user_url` (likewise for Author).

To make sure my routes are correct, I run `rails routes` until I get them written correctly.

## 6. Controllers and Views

At this point, I was ready to start working on the controllers and views. 

### Home Page

First up, I made the controller for the home page:

```
rails generate controller StaticPages home
```

Since want the controller to simply render the home.html.erb view, I don't need to change the controller.  In `views/static_pages/home.html.erb` I added:

```
<h1>BetterBooks</h1>
<p><%= link_to "Authors", authors_path %></p>
<p><%= link_to "Books", books_path %></p>
<p><%= link_to "Users", users_path %></p>
```

These are simply links to the authors, books, and users index pages.  I use the helper methods for the paths.  

## Users

The work for Users is the easiest because in the current app, users don't interact with anything.  In a future version of the app, I can add in the reading lists and ratings, but not now.

Open up `app/controllers/users_controller.rb` and follow along as I draw your attention to some interesting parts of it.

Many of the actions require us to first fetch from the database a particular user given an id in the route.  For example, in the show action:

```ruby
  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end
```

The instance variable `@user` is made available to use in our view.  In Rails, views are tied to the controller and have the same name as the action and are automatically rendered at the end of the action unless there has been another call to `render` or `redirect_to`.  Note that execution of the action method [does not stop after a call to render or redirect_to](https://guides.rubyonrails.org/layouts_and_rendering.html#using-render).  These methods merely work on building the response to the browser. 

When we do a redirect, we should supply a full url, e.g. http://www.example.com/users and not merely a relative path such as /users.  This is why you see `redirect_to users_url` rather than `redirect_to users_path`.  

In `create` and `update` you will see that on success we `redirect_to` another page, and in when failure occurs, we use `render` to display a template.  For `destroy` we always `redirect_to` another page.   All of these actions (create, update, destroy) are designed to modify the database and change the state of the app.  If successful and we stay on the same page, the user could hit refresh in their browser and be prompted to submit the POST request again.  This could cause problems, especially for situations such as placing orders in a commerce app, or debiting an account in an banking app.  With the `redirect_to`, the user will already have done a new request to a benign read only route, and a refresh causes no harm.  This [stackoverflow post about render vs. redirect](https://stackoverflow.com/questions/7493767/are-redirect-to-and-render-exchangeable) is a good read to highlight this issue.

This code: 

```ruby
redirect_to @user
```

seems mysterious.  How in the world does `redirect_to` know what to do?  Short answer is that with RESTful routes and following the naming conventions, rails can figure out that is @user has an id of 6, that it should redirect to a url with /users/6 .  If this bothers you (it kinda bothers me), you can always call `user_url(@user)`, which at least shows that we're using a method that we know should produce a url to /user/id where the id will come from the User object we pass in to it.

You can get access to the helper methods produced by your routes in the rails console by using the `app` object. For example:

```
2.6.6 :003 > u = User.first

2.6.6 :008 > app.user_path(u)
 => "/users/1"
```

so you can at least play with them to see how they work.

Ruby allows us to have private methods, and in the UsersController we have this code:

```ruby
  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      # params is a hashtable.  It should have in it a key of :user.
      # The value for the :user key is another hash.
      # If params does not contain the key :user, an exception is raised.  
      # Only the "user" hash is returned and only with the permitted key(s).
      # So we get back { :name => someName, :email => someEmail}
      params.require(:user).permit(:name, :email)
    end
```

My comment explains what this method does.  This allows us to extract only what we expect from the params hash.  Keep in mind that malicious users (hackers) can send any sort of request to our webserver.  This way, we at least only use the parameter values that we expect and no more.

The hash returned by this method can we used as input to User.new to set the attribute values for a User object:

```ruby
    @user = User.new(user_params)
```

A great question is how do we get the params hash set up to have inside it a hash at the `:user` key?

To understand this, we have to look at the HTML FORM that we're using for both creating and editing User objects.  We keep this form in a "partial" view `app/views/users/_form.html.erb`.  All partial views have a name that starts with an underscore.  Even though the name starts with an underscore, when we ask to render the partial, we do not use the underscore (see [guide](https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials) for details).

The idea of partials is: rather than copy and paste the same code into lots of views, write it in one file and include it via a render statement in another view.

So, when we want to render this form in the `new` view (`app/views/users/new.html.erb`), we do:

```ruby
<%= render 'form', user: @user %>
```

`render` finds the partial in the file `_form.html.erb` and creates a local variable for the partial named `user` that it initializes to the value of `@user`, which is a variable we created in our controller.

Open up `app/views/users/_form.html.erb` to follow along.

The first line is our call to the `form_with` method that builds the HTML FORM for us:

```
<%= form_with(model: user, local: true) do |form| %>
```

The `form_with` method knows how to work with models, and can take a model as an argument via the `model:` parameter. We pass into `form_with` via `model:` the user object (this variable, `user`, was set to @user in our call to `render` for this partial).

Because we are not using javascript, we set `local:` to `true`.  Then, `form_with` is going to execute the block and make available to the block the variable `form`.  We could have used any variable name inside of the vertical bars  `| |` , and you'll see `|f|` used as well as `|form|` in code examples.

Next in the form is the code to print out the error messages from the validations:

```html
  <% if user.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(user.errors.count, "error") %> prevented this user from being saved:</h2>

      <ul>
        <% user.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
```

So, if we try to save or update a User object, and it fails because of a validation, we render this form again, and the error messages will be displayed explaining what was wrong with the input.  Very handy!

Next in the form, we have our two input fields for name and email:

```html
  <div class="field">
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div class="field">
    <%= form.label :email %>
    <%= form.text_field :email %>
  </div>
```

Recall that `<div>` tags are just divisions, much like a paragraph `<p>` tag.  They have a class to allow for CSS styling.

The `form.label` is a call on the `form` object created by `form_with(model: user, local: true) do |form|` to produce an HTML label.  We specify the model's attribute that this label is for: `:name` and `:email`.  Details in [manual](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-label). 

Likewise, `form.text_field` calls [text_field](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-text_field).  

If you view the HTML source produced at `/users/new` you'll see the following:

```html
  <div class="field">
    <label for="user_name">Name</label>
    <input type="text" name="user[name]" id="user_name" />
  </div>

  <div class="field">
    <label for="user_email">Email</label>
    <input type="text" name="user[email]" id="user_email" />
  </div>
```
For the text fields, their `name` are set to `user[name]` and `user[email]`.  When Rails gets a form submission that has key values of the form `alpha[beta]`, in the params hash, it create a key of `:alpha` that has a hash as its value and then sets `params[:alpha][:beta]` to the value submitted in the FORM.  Thus, for the FORM above, we get the user's submitted values via `params[:user][:name]` and `params[:user][:email]`.  So, we finally see why the UsersController method `user_parms` is fetching a hash from `params` keyed to `:user`!

Also, when we look at the HTML, we see that `form_with` know where to submit the form:

```html
<form action="/users" accept-charset="UTF-8" method="post">
```
it knows this again from our RESTful use of models.  In the `new` action handler of the UsersController, we created an empty User object and stored it in `@user`, which eventually is handed to `form_with` via the `user` variable that got its value via the `render` call.  Anyways, **because the user object 
has not been persisted to the database, `form_with` knows that this FORM should POST to "/users" because that is how we create new users!**  

If `form_with` gets a model object that has been persisted, then it "knows" that this needs to be a FORM that submits a PATCH to "/users/", for that is how we update a model.  Details in [manual](https://api.rubyonrails.org/v6.0.3.2/classes/ActionView/Helpers/FormHelper.html#method-i-form_with).

And, for the last great trick of `form_with`, when we supply a model object, the values of the attributes of the model object are used to populate the input fields in the FORM.  

For example, if I go to edit the User with name='Bob', I'll get the following HTML:

```html
  <div class="field">
    <label for="user_name">Name</label>
    <input type="text" value="Bob" name="user[name]" id="user_name" />
  </div>
```
Whoa.  So, if you can master the use of `form_with` and validations, you get a lot of functionality provided for you to easily handle the user interface of the FORMs needed for creating and updating the underlying resources.

How in the world did I get all of this to work?  This is where starting with the scaffolding can be helpful.  It will give you mostly working code, but you need to understand it well enough to get it actually working.  Blindly using scaffolding will just get you a mess that you cannot fix.  If in doubt, code what you understand using the examples in this project.

## Delete

The scaffolding did not produce working delete methods with javascript turned off.  

In the BetterBooks app, I show two ways of getting the web app to produce the correct POST request to delete a resource.

For Users and Authors, I added new "confirm_delete" routes and actions to the UsersController and AuthorsController.  When the user follows a link to /users/7/confirm_delete , the UsersController runs the confirm_delete action handler and passes in 7 via params[:id].  My confirm_delete.html.erb view displays the user associated with the given user and sets up a form to send a DELETE request in for this user:

```html
<%= form_with model: @user, local: true, method: 'delete' do |f| %>
<%= f.submit "Confirm Delete" %>
<% end %>
```

I have to specify the `method:` to be `delete` for this to work.  If we POST, we'll show the user rather than destroy/delete them.

For the Books resource, in the `index` view, I simply put a "Delete" button next to each book:

```html
<%= form_with model: book, method: :delete, local: true do |f| %>
    <%= f.submit 'Delete' %>
<% end %>
```

here, the variable `book` holds a Book object.

Clicking the button deletes the book without asking for any confirmation.

## New Book - Author dropdown

The scaffolding could not add a book unless you as a user knew the book's id!  

To fix this, I modified the `app/views/books/_form.html.erb` partial to provide a dropdown via a FORM SELECT:

```html
<%= form.select(:author_id, Author.to_nested_array_for_select) %>      
```

As the [guide](https://guides.rubyonrails.org/form_helpers.html#select-boxes-for-dealing-with-model-objects) explains, I needed to provide an array of arrays to the select method.  As usual, the place to put this code is in the Author model.  So, I wrote the following in the Author model:

```ruby
  # Creates and array of arrays to use in dropdown selects for author. For more info:  
  # https://guides.rubyonrails.org/form_helpers.html#select-boxes-for-dealing-with-model-objects
  def self.to_nested_array_for_select
     nested = []  
     Author.order(:name).each do |author|
         nested.push [author.name, author.id]
     end
     return nested 
  end
```

Again, the method is `self.to_nested_array_for_select` because I just want to use the Author model to tell me about authors, and I'm not writing a method for an individual author.  

Note that I put a link in the comment for more info.  There is no way I'd remember why I wrote this method in this way without a reference to the document.  

I was careful to order the authors by name to make the dropdown sensible to use.

Long term, my user interface will not work.  Who wants to select an author from a dropdown with thousands of author names?  Not me.  Nevertheless, the functionality is better than it was, and lets us get a first version of the system up and running.  We can always improve it in the future.  Plus, my real goal was to demo a dropdown for you.

## Query Parameters

Go to the Books' index page: "/books" in the web app.

If you click on "Year", "Author", and "Title", the table of books is sorted by year, author, and title.  

Look at the URL in your browser as you click on these links.  You still navigate to `/books` but now it has a query parameter added to it, for example `?order_by=author`.

If you look at `app/views/books/index.html.erb` you can see that I make these links as follows:

```html
      <th><%= link_to 'Title', books_path(order_by: 'title') %></th>
      <th><%= link_to 'Year', books_path(order_by: 'year') %></th>
      <th><%= link_to 'Author', books_path(order_by: 'author') %></th>
```

The `books_path` method will take arguments and convert them to query parameters.  For example, if I did:

```ruby
books_path( hello: 'mark', alpha: 'beta')
```

it would output: `"/books?alpha=beta&hello=mark"`

When a user click on this link, a GET request is sent to the server, and Rails takes everything before the question mark and uses that for routing, and everything after the question mark is added as key value pairs to the `params` hash.  So for `"/books?alpha=beta&hello=mark"`, we would get `params[:alpha]='beta'` and `params[:hello]='mark'` in the books index action handler.

If you've ever used Google (ha ha), when you search you'll see lots of these query parameters in the url.  For example, [https://www.google.com/search?q=uwaterloo+management+engineering](https://www.google.com/search?q=uwaterloo+management+engineering).  

In the BooksController index method, we have:

```ruby
  def index
    # We've added a method, self.order_by, to the Book model, 
    # see models/book.rb
    @books = Book.order_by params[:order_by]
  end
```

So, all we do is call Book.order_by and pass in the `params[:order_by]`, which may be `nil` if no query parameter was provided.

This is an example of passing functionality down to the model.  I could write a bunch of code in the controller to manage sorting of the books, but the controller shouldn't be doing that sort of work.  That is model sort of work.  So, in the Book model we have:

```ruby
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
```

Thankfully, string comparison to `nil` is okay and returns `false`, and so even if the `field` parameter is `nil`, this code works without raising any exceptions.  

Some things to notice:

1. The method is `self.order_by` and not just `order_by`.  When we precede our method name with `self.`, this makes a method on the class Book and not on book objects.  Thus, we call this method as `Book.order_by` without a book object in hand.  This makes sense, for a regular method `order_by` would be respect to a particular Book object, but we want to do something with Books, and so we make a method for the Book class.

1. When I sort by year and author, I have a secondary sort on title and year.  So, when sorting by year, within each year we sort by title.  When sorting by author, we order by the author's name, and then by year of book.

1. To sort by author name, I needed to join Book with the authors table.  (To figure this out, I worked in rails console until I got the query right.)

1. Default sort is by title. So, our books will always be at least sorted by title even if no request is made to sort them.  Users almost never want unsorted lists of material.  It makes sense to sort a table by default on the first, leftmost column that is displayed to the user.

## Tasks: Feature Improvements

Now that you've seen how BetterBooks works, you need to add some feature improvements to it.  This is a scenario that is common to co-op jobs, and daily software engineering.  The company will have an existing system, and you need to go into it and modify the code to add new functionality.  For my first job as a software developer, I was tasked with fixing a bug in the system.  This was a web app with probably more than 100K lines of C++ code, and hundreds of classes. To fix the bug, I had to spend about two weeks reading and learning how the system worked before making the few changes needed to fix the bug.

#### Writing Test Cases

For each change you make, you are required to write a suitable test case to verify the functioning of the change.  If a change needs more than one test case to verify its functionality, you should write multiple test cases.

+ Create a directory named `testing` in your app and in this directory, create a file named `test-cases.txt`.  

+ In this file, using clear formatting, write your test cases to explain to someone how to test that your changes work.  A test case should explain how to set it up, how to input data, and what the expected results are.  

For example, a test case for deleting a book could be:

1. From the homepage, click on 'Books'. 

1. Click on the link 'New Book' and create a new book with title='test delete' and year=2020 and any existing author.

1. Click on "Show Books"

1. Click the "Delete" button next to the "test delete" book.

1. Expected results: A message should be displayed saying "Book was successfully deleted." and the "test delete" book should no longer be listed.

#### Changes to make

Make the following changes to the BetterBooks app and commit and push them and your test cases to GitHub when you have them working.

1. Change Users so that user input for their email address is always downcased before saving in the database.  
   
1. Change the app such that no two users may have the same email address.  Make sure the database disallows users with the same email address, and make sure the User model does a uniqueness validation so that web users are given the correct feedback when they enter an email that has already been used.    

1. Change authors to be represented with both a first and last name.  The first and last name should be separate attributes in the Author model and database. Authors must always have both a first and last name (non-blank).  First and last names may each be a maximum of 35 characters long. The web app user interface should make use of Author model validations to give feedback to users when their input is invalid.  

1. Currently, the confirm_delete page for Authors, tells the user that they first have to delete all books by an author before the author can be deleted.  Change the functionality so that the user is presented with a message explaining that if the author has any books, they must confirm they also want all books deleted.  If the author has any books in the database, provide a listing of the books. When the user confirms the delete, the author and all of the author's books are deleted and the user is informed that the "Author and author's book(s) were successfully deleted." on the authors index page (/authors).

### Submitting your work

Commit and push all work to GitHub.  The time of your last commit is the time of your submission.  If you fail to push your work to GitHub, you will only get credit for the work actually in GitHub!  We cannot check your work unless you have pushed it to GitHub.  












